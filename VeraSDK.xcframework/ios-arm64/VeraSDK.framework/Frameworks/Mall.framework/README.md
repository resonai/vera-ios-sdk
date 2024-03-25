#  The Mall
## Introduction
### What is "The Mall"?
The Mall is a collection of stores designed to **track system data and run operators** based on changes to the data. When data changes, either due to an external entity updating one of the input data stores or an internal operator completing, the Mall will run operators deriving from that data and store it as a result in the output data store. The Mall is designed to handle and schedule these updates in a way that prevents concurrency issues. As such, the Mall can be thought of as a **graph of operators and data**, where some of the data is considered _input_ or _output_ data, and the rest is intermediate (and inaccessible to the caller/external world). The Mall is designed to model a **living, stateful system**, and as such there is no constraint that the graph be acyclical. The design draws inspiration from other operator-flow systems at Resonai as well as from functional reactive programming, (classical non-reactive) functional programming, and finite state machines.

## Concepts and Design
### Data (Stores)
The system holds a container store for each data item it tracks, including inputs, outputs, and intermediates. The data _instance_ held by the container may change over time, but the container persists through the life of the application. Stores currently come in a single variety:
- **published** stores, which have an associated publisher that notifies subscribers of changes to its instance value.

### Operator Functions
These are implemented as pure static functions with the signature corresponding to the input types and output types with multiplicity. Future versions may broaden the ways to define operators.

#### Filters
In certain situations, it is desirable for the operator _not_ to write to its downstream, thereby breaking the chain of event propagation. In this case the operator signature can be modified to include a boolean (where `true` indicates that the value is propagated and `false` ceases the propagation). Namely, given an operator function of signature `f: A? -> V?` it can be made to filter by extending its signature to `f: A? -> (Bool, V?)`.

### Dependency types
Operators must update one or more output data stores.

Operators can depend on input data stores in one of a number of ways:
- **trigger** dependency, which creates a subscription to the data store's publisher and causes the operator to run whenever the data store is updated;
- **reads** dependency, which returns the value in the store when the operator is triggered, but does not itself cause the operator to run;
- **zip** dependency, which waits until all the inputs have produced an output and then returns them together (analogous to Zip in Combine itself).

## The iOS Mall
### Defining a Mall in iOS
Malls must implement the `Mall` protocol.

Each data item they track (node in the graph) should be a member variable that is compatible with `InputNode` and `OutputNode` - typically a `CurrentValueSubject`.

Inside the `prepareDataOpsGraph` function should be a list of `op` blocks linking input nodes to output nodes via operators. Swift syntactic sugar allows us to fill the function with statements like
```
op {
  [ inputs with dependency relationship ]
  [ operator function ref ]
  [ outputs wrapped with output node ]
}
```
where we list input nodes, then operator, then output nodes. The input nodes are marked with their dependency type (`Trigger`, `Reads`, `Zip`). The output member variable is marked (wrapped) as an output node.

For instance, the op block below defines a relationship between the variables `inputA` and `inputB`, calling operator `functionOf(a:b:)`, writing to `outputC`. In this example, changes to `inputA` cause the function to run with the last value of `inputB` pulled in (its updates do not cause the function to run).
```
op {
    Trigger(inputA)
    Reads(inputB)

    functionOf(a:b:)

    OutputNode(outputC)
}
```

#### Shorthand notation
Dependencies can be defined using a set of shorthand operators (note, the term "operator" is overloaded here to refer to the extension of Swift syntax, not a function that runs in Combine/Mall!):
- postfix `>!` : trigger
- postfix `>?` : reads
- postfix `>%` : zip
- prefix `~>` : output

Thus an operator block can written as
```
op {
   [ inputs with postfix operators ]
   [ operator function ref ]
   [ outputs with prefix operator ]
}
```
and the example above is simplified to
```
op {
    inputA>!
    inputB>?

    functionOf(a:b:)

    ~>outputC
}
```

### Behind the Scenes
The iOS implementation of the Mall relies heavily on [Combine](https://developer.apple.com/documentation/combine), which in turn follows in the paradigm of [ReactiveX](http://reactivex.io/) and in particular [RxSwift](https://github.com/ReactiveX/RxSwift).

Additionally, we make use of [Result Builders](https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md) to define a compiled, type-checked [domain-specific language](https://developer.apple.com/videos/play/wwdc2021/10253/) for defining operator dependencies.

Published stores are implemented as [CurrentValueSubjects](https://developer.apple.com/documentation/combine/currentvaluesubject), whereas values stores are given through a custom implementation, ValuesCache, which uses DispatchSemaphores for synchronization. A ValuesCache may store a limited or unlimited cache of a data item.

### Optionals
Given that stores may store an item or none, general operator signatures must make use of Optionals. Special care should be taken with regard to Optional.

### Concurrency behavior, limitations, and gotchas
Apple has not documented Combine concurrency edge cases thoroughly. The best exploration known to me at the time of this writing is Matt Gallagher's [22 Short Tests of Combine](https://www.cocoawithlove.com/blog/twenty-two-short-tests-of-combine-part-3.html). Also see related tests in MallTest.swift.

Some behaviors that have been derived empirically for Combine and the Mall are:
- In general, unless otherwise specified, operators run on the thread in which the publisher is sent to.
- Sending to Subjects (and by extension `MallNodes`) is threadsafe and protected by an `os_unfair_lock`.
- Transforms (maps of a publisher/mall node) and sinks are mutexed
    - Only one instance can run at a time, even given concurrent upstream values.
    - This does not guarantee consistency if there is a reentrant path (i.e. two downstream ops may run nonconcurrently but the second will potentiallly have stale input). This may be mitigated by use of queues (see TransformApplicative*)
- Reentrancy from a single queue is handled naturally, but caution should be taken with respect to concurrent reentrancy (whether due to a single operator or a cycle). **Concurrent reentrancy can induce deadlocks** (each of the two senders will wait indefinitely for the other to complete).
- It has been observed that Combine's `CombineLatest` functions, which back most of the Mall's behavior, **may drop values under extreme concurrent load**, e.g. if hundreds of sends occur concurrently, there may be fewer receives.

### Future technology
It is expected that Swift 5.6 will [significantly lift constraints on protocol polymorphism](https://github.com/apple/swift/pull/33767), which is likely to simplify this implementation considerably.

[Actors](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html#ID645) should provide a more idiomatic and elegant way to handle concurrency in the context of MallNodes.
