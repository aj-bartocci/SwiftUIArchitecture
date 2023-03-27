
# SwiftUI Architecture 

## Why? 

Currently SwiftUI does not define an specific way of doing things, but instead Apple has provided many different building blocks like @Envrionment, @EnvironmentObject, @StateObject, etc. However, there doesn't seem to be a consistent way of ow to do things in a scalable way. The example apps that Apple shows are usually quite simple and almost all the business logic lives in the Views themselves - is this how Apple intended SwiftUI to be? It seems unlikely as this makes testing a nightmare and sharing global state becomes difficult. This points to a need for a blueprint on how to handle the unique needs of the iOS environment. Many devs are coming from years of MVC, MVVM, MV-whatever and are now left scrambling to figure out how SwiftUI should fit into all of this. Everyone is on the same page that building the UI out is incredibly fast, however problems arise when apps begin to scale.

Apple will probably create some type of framework at some point to help address these things, but who knows when and more importantly if it will be backwards compatable (probably not). So in the meantime it is helpful to benchmark and see where problems arise with certain strategies 

## Benchmarking

A basic project has been set up that pushes 5 views onto a Navigation stack. Each view accesses a piece of the state object provided by the environment. On the last View of the stack there is a button that triggers 1000 updates to a specific property on the environmnet object. This value is only consumed by the View that triggered it. The goal is to see how the UI handles this flood of updates since the object lives in the environment. 

The current benchmarking focuses around using MVVM with a Redux-like global state. This is simply because this is what is most important for a current project's needs, however additional benchmarking will be added over time.

Passing shared state via SwiftUI's environment allows us to get incredible dependency injeciton for free, which keeps our Views and ViewModels decoupled from each other yet testable. This is key component in finding what solutions work best - leaning into SwiftUI's strengths. 

### @EnvironmentObject Benchmark Results
Two strategies were used for building the Views. 
1. The 'vanilla' way which simply passes @EnvironmentObject to each View
Pros: 
- Simple and clean View heirarchy 
Cons:
- Very difficult to do MVVM since some values are in the Environment which cannot be accessed outside of a View, and when accessed in a View it happens at render time. There are some hacky strategies that involve using optionals and setup during `onAppear` but feel wrong. 
- Causes a lot of 'unnecessary' renders for changes the the View does not actually consume
 
2. The 'wrapped' way which adds an additional View layer to each View that consumes @EnvironmentObject
Pros:
- Easy to use MVVM since values the view wants come in via initializer, which can be passed to ViewModel
- Cuts down on total View renders when working with state that updates frequently 
Cons: 
- Makes the View hierarchy more complex 
- Doubles the amount of Views needed 

It may come as a surprise but the 'wrapped' strategy performed better than the 'vanilla' way. Even though wrapping Views effectively doubles the total amount of Views being used, it cuts the amount of renders in 1/2. This is becuase of how @EnvironmentObject actually triggers a View refresh. If ANY property of an @EnvironmentObject model changes then the View containing it will re-render, which becomes problematic when a View only cares about a single property but refreshes when other properties that it does not care about change. When wrapping a View less refreshes happen because only the wrapper View refreshes which does not contain any actual changes, the inner view does not refresh because the data it cares about did not actually change. It's a small difference but it makes a huge difference in View rendering at scale. 
 
< attach screenshots here > 

### @Environment (with class object) Benchmark Results
TBD


## Goals of Benchmarking 
- Feel Swifty
    - There are a lot of opinions and answers on the internet. Many of which are straight up wrong, or feel like what we are doing is fighting the framework
- Scaling
    - find what seems to scale in different situations
- Be testable
    - This goes along with scaling. The architecture should be accomodate testing but not be beholden to it
