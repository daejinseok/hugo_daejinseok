+++
date  = "2017-11-27T23:18:00+09:00"
title = "리액트 라우터 철학"
tags  = ["react", "react-router", "philosophy"]
+++

원문 [React-Router - Philosophy](https://reacttraining.com/react-router/web/guides/philosophy)

### Philosophy

This guide’s purpose is to explain the mental model to have when using React Router. We call it “Dynamic Routing”, which is quite different from the “Static Routing” you’re probably more familiar with.

### 철학

이 가이드의 목적은 리액트 라우터을 사용함에 있어 필요한 개념을 설명하는 것이다. 이것은 정적 라우팅과 다른 동적 라우팅과 비슷합니다.

### Static Routing

If you’ve used Rails, Express, Ember, Angular etc. you’ve used static routing. In these frameworks, you declare your routes as part of your app’s initialization before any rendering takes place. React Router pre-v4 was also static (mostly). Let’s take a look at how to configure routes in express:

### 정적 라우팅

Rails, Express, Ember, Angular 등등을 사용해봤다면, 이미 정적 라우팅을 사용해 본 것입니다. 이러한 프레임워크에서는 경로에 대해 해석(rendering)하기 전에 앱 초기화 부분에서 라우팅을 선언합니다. React Router pre-v4 또한 거이 정적입니다. 아래는 express에서 라우팅을 어떻게 설정하는지 보여 줍니다.

```javascript
app.get('/', handleIndex)
app.get('/invoices', handleInvoices)
app.get('/invoices/:id', handleInvoice)
app.get('/invoices/:id/edit', handleInvoiceEdit)

app.listen()
```

Note how the routes are declared before the app listens. The client side routers we’ve used are similar. In Angular you declare your routes up front and then import them to the top-level AppModule before rendering:

앱이 요청을 받기전에 라우팅을 어떻게 동작하는지 선언되어야 한다. 클라이언트 측 라우터도 비슷하게 사용한다. 

```javascript
const appRoutes: Routes = [
  { path: 'crisis-center',
    component: CrisisListComponent
  },
  { path: 'hero/:id',
    component: HeroDetailComponent
  },
  { path: 'heroes',
    component: HeroListComponent,
    data: { title: 'Heroes List' }
  },
  { path: '',
    redirectTo: '/heroes',
    pathMatch: 'full'
  },
  { path: '**',
    component: PageNotFoundComponent
  }
];

@NgModule({
  imports: [
    RouterModule.forRoot(appRoutes)
  ]
})

export class AppModule { }
```

Ember has a conventional routes.js file that the build reads and imports into the application for you. Again, this happens before your app renders.

Ember에는 라우터에 대한 정보를 읽고 가져와서 어플리케이션에 넣을 수 있는 빌드한 편리한 routes.js 파일이 있으며, 이는 앱이 해석되기 전에 수행된다.

```js
Router.map(function() {
  this.route('about');
  this.route('contact');
  this.route('rentals', function() {
    this.route('show', { path: '/:rental_id' });
  });
});

export default Router
```

Though the API’s are different, they all share the model of “static routes”. React Router also followed that lead up until v4.

To be successful with React Router, you need to forget all that! :O



### Backstory

To be candid, we were pretty frustrated with the direction we’d taken React Router by v2. We (Michael and Ryan) felt limited by the API, recognized we were reimplementing parts of React (lifecycles, and more), and it just didn’t match the mental model React has given us for composing UI.

We were walking through the hallway of a hotel just before a workshop discussing what to do about it. We asked each other: “What would it look like if we built the router using the patterns we teach in our workshops?”

It was only a matter of hours into development that we had a proof-of-concept that we knew was the future we wanted for routing. We ended up with API that wasn’t “outside” of React, an API that composed, or naturally fell into place, with the rest of React. We think you’ll love it.



### Dynamic Routing

When we say dynamic routing, we mean routing that takes place as your app is rendering, not in a configuration or convention outside of a running app. That means almost everything is a component in React Router. Here’s a 60 second review of the API to see how it works:

First, grab yourself a Router component for the environment you’re targeting and render it at the top of your app.




```js
// react-native
import { NativeRouter } from 'react-router-native'

// react-dom (what we'll use here)
import { BrowserRouter } from 'react-router-dom'

ReactDOM.render((
  <BrowserRouter>
    <App/>
  </BrowserRouter>
), el)
```

Next, grab the link component to link to a new location:

```js
const App = () => (
  <div>
    <nav>
      <Link to="/dashboard">Dashboard</Link>
    </nav>
  </div>
)
```

Finally, render a Route to show some UI when the user visits /dashboard.

```js
const App = () => (
  <div>
    <nav>
      <Link to="/dashboard">Dashboard</Link>
    </nav>
    <div>
      <Route path="/dashboard" component={Dashboard}/>
    </div>
  </div>
)
```

The Route will render <Dashboard {...props}/> where props are some router specific things that look like { match, location, history }. If the user is not at /dashboard then the Route will render null. That’s pretty much all there is to it.

# Nested Routes
Lots of routers have some concept of “nested routes”. If you’ve used versions of React Router previous to v4, you’ll know it did too! When you move from a static route configuration to dynamic, rendered routes, how do you “nest routes”? Well, how do you nest a div?

```js
const App = () => (
  <BrowserRouter>
    {/* here's a div */}
    <div>
      {/* here's a Route */}
      <Route path="/tacos" component={Tacos}/>
    </div>
  </BrowserRouter>
)

// when the url matches `/tacos` this component renders
const Tacos  = ({ match }) => (
  // here's a nested div
  <div>
    {/* here's a nested Route,
        match.url helps us make a relative path */}
    <Route
      path={match.url + '/carnitas'}
      component={Carnitas}
    />
  </div>
)
```

See how the router has no “nesting” API? Route is just a component, just like div. So to nest a Route or a div, you just … do it.

Let’s get trickier.

# Responsive Routes
Consider a user navigates to /invoices. Your app is adaptive to different screen sizes, they have a narrow viewport, and so you only show them the list of invoices and a link to the invoice dashboard. They can navigate deeper from there.

```python
Small Screen
url: /invoices

+----------------------+
|                      |
|      Dashboard       |
|                      |
+----------------------+
|                      |
|      Invoice 01      |
|                      |
+----------------------+
|                      |
|      Invoice 02      |
|                      |
+----------------------+
|                      |
|      Invoice 03      |
|                      |
+----------------------+
|                      |
|      Invoice 04      |
|                      |
+----------------------+
```

On a larger screen we’d like to show a master-detail view where the navigation is on the left and the dashboard or specific invoices show up on the right.

```python
Large Screen
url: /invoices/dashboard

+----------------------+---------------------------+
|                      |                           |
|      Dashboard       |                           |
|                      |   Unpaid:             5   |
+----------------------+                           |
|                      |   Balance:   $53,543.00   |
|      Invoice 01      |                           |
|                      |   Past Due:           2   |
+----------------------+                           |
|                      |                           |
|      Invoice 02      |                           |
|                      |   +-------------------+   |
+----------------------+   |                   |   |
|                      |   |  +    +     +     |   |
|      Invoice 03      |   |  | +  |     |     |   |
|                      |   |  | |  |  +  |  +  |   |
+----------------------+   |  | |  |  |  |  |  |   |
|                      |   +--+-+--+--+--+--+--+   |
|      Invoice 04      |                           |
|                      |                           |
+----------------------+---------------------------+
```

Now pause for a minute and think about the /invoices url for both screen sizes. Is it even a valid route for a large screen? What should we put on the right side?

```python
Large Screen
url: /invoices
+----------------------+---------------------------+
|                      |                           |
|      Dashboard       |                           |
|                      |                           |
+----------------------+                           |
|                      |                           |
|      Invoice 01      |                           |
|                      |                           |
+----------------------+                           |
|                      |                           |
|      Invoice 02      |             ???           |
|                      |                           |
+----------------------+                           |
|                      |                           |
|      Invoice 03      |                           |
|                      |                           |
+----------------------+                           |
|                      |                           |
|      Invoice 04      |                           |
|                      |                           |
+----------------------+---------------------------+
```

On a large screen, /invoices isn’t a valid route, but on a small screen it is! To make things more interesting, consider somebody with a giant phone. They could be looking at /invoices in portrait orientation and then rotate their phone to landscape. Suddenly, we have enough room to show the master-detail UI, so you ought to redirect right then!

React Router’s previous versions’ static routes didn’t really have a composable answer for this. When routing is dynamic, however, you can declaratively compose this functionality. If you start thinking about routing as UI, not as static configuration, your intuition will lead you to the following code:

```js
const App = () => (
  <AppLayout>
    <Route path="/invoices" component={Invoices}/>
  </AppLayout>
)

const Invoices = () => (
  <Layout>

    {/* always show the nav */}
    <InvoicesNav/>

    <Media query={PRETTY_SMALL}>
      {screenIsSmall => screenIsSmall
        // small screen has no redirect
        ? <Switch>
            <Route exact path="/invoices/dashboard" component={Dashboard}/>
            <Route path="/invoices/:id" component={Invoice}/>
          </Switch>
        // large screen does!
        : <Switch>
            <Route exact path="/invoices/dashboard" component={Dashboard}/>
            <Route path="/invoices/:id" component={Invoice}/>
            <Redirect from="/invoices" to="/invoices/dashboard"/>
          </Switch>
      }
    </Media>
  </Layout>
)
```

As the user rotates their phone from portrait to landscape, this code will automatically redirect them to the dashboard. The set of valid routes change depending on the dynamic nature of a mobile device in a user’s hands.

This is just one example. There are many others we could discuss but we’ll sum it up with this advice: To get your intuition in line with React Router’s, think about components, not static routes. Think about how to solve the problem with React’s declarative composability because nearly every “React Router question” is probably a “React question”.