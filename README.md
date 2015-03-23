hamsa
=====
A dead simple, data-binding & observable model.


#### IS hamsa FOR YOU?
A revolution is coming. There’s a new addition to JavaScript that’s going to change everything you think you know about data-binding. It’s also going to change how many of your MVC libraries approach observing models for edits and updates. Are you ready for some sweet performance boosts to apps that care about property observation? `Object.observe()`, part of a future ECMAScript standard, is a method for asynchronously observing changes to JavaScript objects...without the need for a separate library. It allows an observer to receive a time-ordered sequence of change records which describe the set of changes which took place to a set of observed objects.

Hamsa will help you use this new specification today. No need to worry if your browser supports `Object.Observe()` because Hamsa comes with polyfill perfect for those older browsers. Anyway, it is much more than a polyfill the main objective is to provide you a system object modeling javascript for all your projects. You can create complex models and control all its mutations. It's time to start working with Hamsa...

#### INSTALL AND USE hamsa
Hamsa is registered as a package with Bower. You can install the latest version of Hamsa with the command:

```
bower install hamsa
```

This will install Hamsa to Bower's install directory, the default being bower_components. Within bower_components/hamsa/dist/ you will find a compressed release file. The Hamsa Bower package contains additional files besides the default distribution. In most cases you can ignore these files.

The bare minimum for using hamsa on a web page is linking to the library:

```
<script src="/path/to/hamsa.js">;</script>;
```

Hamsa is registered also as a Node package with NPM. You can install the latest version of Hamsa with the command:

```    
npm install hamsa
```

If you want use hamsa in your NodeJS project you only need `require` the library after install via NPM:

```
Hamsa = require "Hamsa"
```

####DEFINE YOUR FIRST hamsa CLASS

Usually you find MVC frameworks where the model becomes complex and heavy. With Hamsa wont have that feeling, the model does exactly what you need without becoming complex conventions, simple but powerfull, let's see how to create one:

```
class Contact extends Hamsa
  @define
    id              : type: String
    mail            : type: String
    username        : type: String
    avatar          : type: String, default: "http://gravatar.org"
    networks        : type: Object
    since           : type: Number, default: 2015
    created_at      : type: Date, default: new Date()
```

As you can see you have to use the inherited function `@define` for setting fields will have your model. Must indicate the type of security you need and if you can set a default value. Easy, right? Ipsum.

####CREATING hamsa INSTANCES
Once you have defined your first Hamsa class you can start creating new instances of it. As you'll be able to check is really easy:

```
contact = new Contact()
#> {avatar: "http://gravatar.org", since: 2015, created_at: Sat Mar 21 2015 16:21:04 GMT+0700 (ICT)}
```
This is the simplest example, instantiating has no parameters but as you can see the default fields are filled. Now that we have our instance we can create, modify or delete their fields.

```
contact.username = "@soyjavi"
contact.mail = "hi@soyjavi.com"
delete contact.since
```
Now we will create a new instance by setting values for certain fields:

```
contact = new Contact username: "@soyjavi", since: 1980
#> {username: "@soyjavi", since: 1980, avatar: "http://gravatar.org", created_at: Sat Mar 21 2015 16:21:04 GMT+0700 (ICT)}
```

If you want to delete a particular instance you only have to use the `destroy` method and hamsa do the rest. In the next chapter we will learn to observe the mutations both instances and class.

```
contact.destroy()
#> undefined
```

####OBSERVE YOUR hamsa CHANGES
Now that you know how to create your own Hamsa classes and how to create instances of these. Now you should know as you can see both mutations Hamsa class and its instances. We will begin to observe, `Contact`, the Hamsa class you have defined in our case. You only have to define a function for collect mutations and also set the mutations we want observe:

```
Contact.observe (state) ->
  console.log "Contact.observe", state
, MUTATIONS = ["add", "delete"]
```

To start observing a Hamsa Class just have to have to use the `observe` method. The first parameter is the callback function and the second one is an array of mutations that you want to observe. Now, you can create instances of your hamsa Class and see how each new instance (if you have subscribed to the `"new"` mutation) have a message on your console.

```
contact = new Contact()
###
> Contact.observe {
  type  : "add",
  object: Object,
  ...}
###
```

If you have subscribed to the mutation `"delete"` you can delete any of your instances and watch as the observer reported on your console change.

```
contact.destroy()
###
> Contact.observe {
  type  : "delete",
  object: Object,
  ...}
###
```

As has been shown is easy to observe the mutations of Hamsa class. Now you will learn to manage mutations in a particular instance, for it can do in two ways. The first is the same as the class using the `observe` method:
      
```
callback = (state) -> console.log "#{state.object.username}.observe", state

contact.observe callback, ["add", "update"]
```

The second way is to define the observer when creating the instance:
        
```
javi = new Contact username: "@soyjavi", callback, ["add", "update"]
```

Now also if you modify or create (remember you only observe mutations `"add"` and `"update"`) any of the fields of your instance we shall have a reference of that change in your console:

```
javi.username = "@javi"
###
> @javi.observe {
  type    : "update"
  name    : "username"
  oldValue: "@soyjavi"
  object  : Object
  ...}
###

javi.mail = "hi@soyjavi.com"
###
> @javi.observe {
  type    : "add"
  name    : "mail"
  object  : Object }
###
```

In our Hamsa Class we set that we want to know if any of the instances are removed (using the key `"delete"`). Well, now you will use the class method `destroyAll` to remove all instances and see on your console each element destroyed:

```
do Contact.destroyAll

###
> Contact.observe {type: "delete"...}
> Contact.observe {type: "delete"...}
###
```

####SELECT YOUR hamsa INSTANCES
Finally you will learn how to select instances of a particular Hamsa Class. To do this we will use the class method `find` which receives a filtering function and returns an array of instances that fulfill that function.

```
Contact.find (instance) ->
  if instance.since < 2014 and instance.username is "@javi"

###
> [ {username: "@javi", ...} ]
###
```

In case you want to filter for a particular field you can use the method of `findBy` class. Unlike with the `find` method in this case you must set two parameters, the first is the field you want to filter and the second one the exact search value.

Contact.findBy "username", "@javi"

```
###
> [{username: "@javi", ...}]
###
```

