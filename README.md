
# SwiftUI Architecture 

## Why? 
![tradeoffs-graphic](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/tradeoffs.jpg?raw=true)

Currently SwiftUI does not define an specific way of doing things, but instead Apple has provided many different building blocks like @Envrionment, @EnvironmentObject, @StateObject, etc. However, there doesn't seem to be a consistent way of how to do things in a scalable way. The example apps that Apple shows are usually quite simple and almost all the business logic lives in the Views themselves - is this how Apple intended all SwiftUI projects to be? It seems unlikely as this makes testing a nightmare and sharing global state becomes difficult. 

This points to a need for a blueprint on how to handle the unique needs of the iOS environment. Many devs are coming from years of MVC, MVVM, MV-whatever and are now left scrambling to figure out how SwiftUI should fit into all of this. Everyone is on the same page that building the UI out is incredibly fast, however problems arise when apps begin to scale.

Choosing the "best" architeccture to suit your projects needs will pay off greatly, __BUT__ this is dependent on the project. It seems there is not 1 best way when using SwiftUI because a lot of control has been given over to the black box that is SwiftUI. UIKit gave developers very fine grained control over their UI elements, SwiftUI in its current state forces developers to rely on what Apple has provided with much less room for customization. 

Apple will probably create some type of framework at some point to help address these things, but who knows when and more importantly if it will be backwards compatable (probably not). So in the meantime it is helpful to benchmark and see where problems arise with certain strategies

## Elm & SwiftUI
SwiftUI was created based off of [Elm](https://elm-lang.org), so it would be logical to think to do SwiftUI like Elm web apps. However, it's not as simple as that. Elm suggests creating large files that represent whole pages rather than splitting into smaller reusable components, i.e. a home page would be a single large file that contains a single view model, and all child views together. This allows state mutations from any of the children to happen directly to the view model that is used for the whole page [(source)](https://guide.elm-lang.org/webapps/structure.html#:~:text=elm%2Dlang.org-,Culture%20Shock,-Folks%20coming%20from).

Structuring a web app in this way actually makes a lot of sense, since only a single page is shown at a time. But, this does not make sense when doing a mobile app since we are pushing many views onto a stack that a web app could represent as a single page. The view/state boundaries are much less frequent when working in Elm than they are when working in SwiftUI. Becuase of these differences, it points to needing a solution that is more suited to mobile apps. 

## Goals of Benchmarking 
- Feel Swifty
    - There are a lot of opinions and answers on the internet. Many of which are straight up wrong, or feel like what we are doing is fighting the framework
- Scaling
    - find what seems to scale from a performance perspective in different situations
- App structure should be testable
    - This goes along with scaling. The architecture should be accomodate testing but not be beholden to it

## Benchmarking
A basic project has been set up that pushes 5 views onto a Navigation stack. Each view accesses a piece of the state object provided by the environment. On the last View of the stack there is a button that triggers 1000 updates to a specific property on the environmnet object. This value is only consumed by the View that triggered it. The goal is to see how the UI handles this flood of updates since the object lives in the environment. 

The benchmarking is based on navigating to the last screen of the stack and triggering 1000 updates to the environment object, which takes about a minute. 

The current benchmarking focuses around using MVVM with a Redux-like global state. This is simply because this is what is most important for a current project's needs, however additional benchmarking will be added over time.

Passing shared state via SwiftUI's environment allows us to get incredible dependency injeciton for free, which keeps our Views and ViewModels decoupled from each other yet testable. This is key component in finding what solutions work best - leaning into SwiftUI's strengths. 

## MVR (Model View Redux)
TBD on naming but MVR sounds cool and can play on saying 'mover'

Stands for `Model View Redux` but is basically just MV with 2 way binding disabled in favor of dispatching actions, which allows us to mantain a centralized point for data mutations. 

Benchmarking will be very similar to regular MV. 

### __The MVR tradeoff__
TBD

## MV (Model View)
TODO: add description/links of what MV architecture is 

When the state objects used with MV are separated nicely then the Views will be pretty performant, this is a big if though. This means that state design partially depends on the UI which feels a little weird.

In practice MV should be used without trying to guess on optimizations, with the one exception being state that is known to update frequently, like data dependent on a web socket or a lot of user interaction. For a majority of cases if state triggers unnecessary view refreshes it should be negligable on performance. Best practice would be to just separate frequently updating state to their own state objects when needed. 

The benchmarking was done with state objects that were completely separated from which gave great performance metrics (quite similar to the wrapped Env object strategy), however this is an optimistic separation of state. 

### __The MV tradeoff__
The MV architecture feels very SwiftUI-like, things just hookup and work quite nicely. However, this requires state objects in the enviornment that live beyond the lifecycle of the views that use them

![MV-Device-1-graph](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/MV-Device-1-graph.png?raw=true)
![MV-Device-1-summary](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/MV-Device-1-summary.png?raw=true)

TODO: show benchmark where state is not separated as cleanly 

## Redux
TODO: add description/links of what Redux is 

### __The Redux tradeoff__
Doing Redux with SwiftUI is quite easy and simple to understand. From a design perspective structs can easily represent the state object(s) and an ObservableObject can easily facilitate the role of the Store. However, it is quite poor from a performance perspective, since all views update on every change to the state object.

![Redux-Device-1-graph](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/Redux-Device-1-graph.png?raw=true)
![Redux-Device-1-summary](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/Redux-Device-1-summary.png?raw=true)

## MVVM (Model View ViewModel)
TODO: add description/links of what MVVM is

Attemtping to use MVVM with SwiftUI works but requires View wrapping and boilerplate code. There is nothing particularly wrong with this approach but it introduces a lot of manual steps to access the environment values within a ViewModel. Because of these manual steps it feels as if the developer is fighting against SwiftUI rather than leaning into its strengths. 

### __The MVVM tradeoff__
Having simplistic code vs manual boilerplate code. MVVM does provide the most control over how views are interacting with state and maintaining testability, however there is a lot more responsibility on the dev to make sure the ViewModels are hooked up correctly. 

![MVVM-Device-1-graph](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/MVVM-Device-1-graph.png?raw=true)
![MVVM-Device-1-summary](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/MVVM-Device-1-summary.png?raw=true)

## @EnvironmentObject Benchmark Results
Two strategies were used for building the Views. 
1. The 'vanilla' way which simply passes @EnvironmentObject to each View

Pros: 
- Simple and clean View heirarchy 

Cons:
- Very difficult to do MVVM since some values are in the Environment which cannot be accessed outside of a View, and when accessed in a View it happens at render time. There are some hacky strategies that involve using optionals and setup during `onAppear` but feel wrong. 
- Causes a lot of 'unnecessary' renders for changes the the View does not actually consume
```Swift
struct ViewOne: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        VStack {
            Text("Foo: \(state.foo)")
            Text("Bar: \(state.bar)")
            Text("Baz: \(state.baz)")
            Button("Update Foo") {
                state.foo = "New from View One"
            }
            NavigationLink("Push View Two") {
                LazyView(ViewTwo())
            }
        }
    }
}
```
 
2. The 'wrapped' way which adds an additional View layer to each View that consumes @EnvironmentObject

Pros:
- Easy to use MVVM since values the view wants come in via initializer, which can be passed to ViewModel
- Cuts down on total View renders when working with state that updates frequently

Cons: 
- Makes the View hierarchy more complex 
- Doubles the amount of Views needed 

Pro/Con
- Explicitly pulling off state & functions from the EnvironmentObject
```Swift
struct WrappedViewOne: View {
    @EnvironmentObject var state: GlobalStateObject
    
    var body: some View {
        Content(
            foo: state.foo,
            bar: state.bar,
            baz: state.baz
        )
    }
    
    struct Content: View {
        let foo: String
        let bar: String
        let baz: String
        
        var body: some View {
            VStack {
                Text("Foo: \(foo)")
                Text("Bar: \(bar)")
                Text("Baz: \(baz)")
                Button("Update Foo") {
                    // would need to pass an update function in 
                    // or some type of 2 way binding
                    // state.foo = "New from View One"
                }
                NavigationLink("Push View Two") {
                    LazyView(WrappedViewTwo())
                }
            }
        }
    }
}
```

It may come as a surprise but the 'wrapped' strategy performed better than the 'vanilla' way. Even though wrapping Views effectively doubles the total amount of Views being used, it cuts the amount of renders in 1/2. This is becuase of how @EnvironmentObject actually triggers a View refresh. If ANY property of an @EnvironmentObject model changes then the View containing it will re-render, which becomes problematic when a View only cares about a single property but refreshes when other properties that it does not care about change. When wrapping a View less refreshes happen because only the wrapper View refreshes which does not contain any actual changes, the inner view does not refresh because the data it cares about did not actually change. It's a small difference but it makes a huge difference in View rendering at scale. 
 
### Vanilla @EnvironmentObject Benchmarking on Device
![VanillaEnvObj-Device-1-graph](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/VanillaEnv-Device-1-graph.png?raw=true)
![VanillaEnvObj-Device-1-summary](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/VanillaEnv-Device-1-summary.png?raw=true)

### Wrapped @EnvironmentObject Benchmarking on Device
![WrappedEnvObj-Device-1-graph](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/WrappedEnv-Device-1-graph.png?raw=true)
![WrappedEnvObject-Device-1-summary](https://github.com/aj-bartocci/SwiftUIArchitecture/blob/main/SwiftUIArchitecture/Assets/Profiling/WrappedEnv-Device-1-summary.png?raw=true)

The Vanilla @EnvironmentObject has ~60,000 View renders, while (surprisingly?) the Wrapped @EnvironmentObject has ~30,000 View renders. This may seem surprising but when looking at how @EnvironmentObject operates under the hood it's actually not surprising, since @EnvironmentObject triggers the View consuming it to re-render on every change, even if it's a change the View does not care about. 

Just looking at View renders and animation commits really only matters based on what the application is doing. For many projects this performance difference probably isn't very noticeable. However, when dealing with an app that is frequently updating the EnvironmentObjects (socket based updates, heavy useer interaction) this performance issue will be much more noticeable.

Additional benchmarks done on simulator are included inthe Profiling folder but seem like overkill to include here. On simulator the same trends were seen (on a more drastic scale). 

### @Environment (with class object) Benchmark Results
TBD
