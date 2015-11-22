console.log "\n"

# -- Test

class window.Contact extends Hamsa

  @define
    id              : type: Number
    mail            : type: String
    username        : type: String
    avatar          : type: String, default: "http://gravatar.org"
    name            : type: String
    networks        : type: Object
    since           : type: Number, default: 2014
    followers       : type: Array, default: ["zetapath"]
    created_at      : type: Date, default: new Date()

  @fullname: ->
    console.log "???fullname"

# -- Observe
state1 = (state) ->
  console.log "1.Observe [#{state.type}]", state.object.username
state2 = (state) ->
  console.info " 2.Observe [#{state.type}]", state.object.username
state3 = (state) ->
  console.error "  3.Observe [#{state.type}]", state.object.username

Contact.observe state1
Contact.observe state2

new Contact id: i, username: "user_#{i}",  name: "name_#{i}" for i in [1..5]
javi = new Contact username: 'soyjavi'
javi.observe state3
javi.username = '@soyjavi'

setTimeout =>
  console.log '1000ms'
  Contact.unobserve state2
  # javi.unobserve()
, 1000

setTimeout =>
  new Contact id: i, username: "user_#{i}",  name: "name_#{i}" for i in [6..10]
  javi.username = 'javi'
, 2000


# console.log Contact.find()

# console.log Contact.find id: 1, username: 'user_1'


# console.log Contact.findAndModify
#   query : id: 1, name: 'name_1'
#   update: username: 'one'
#   upsert: false

# console.log Contact.findAndModify
#   query : id: 123, name: 'name_1'
#   update: username: 'one'
#   upsert: true

# console.log Contact.findAndModify
#   query : since: 2014
#   update: since: 2015
#   upsert: false

# console.log Contact.find()

# console.log 'since'
# console.log Contact.findOne since: 2015
# console.log Contact.findOne since: 2014

# first_uid = Contact.find()[0].uid
# console.log first_uid, Contact.findOne uid: first_uid



# return true
# Contact.observe (state) ->
#   console.log "\nContact.observe #{state.type} [#{state.name}]", state

# observe = (state) ->
#   object = state.object or state.oldValue
#   console.log " - #{object.username}.observe #{state.type} [#{state.name}]", state

# javi = new Contact
#   username: "Javi", twitter: "@soyjavi", mail: "javi@tapquo.com", since: "1980"
#   , observe
#   , ["add", "update", "delete"]

# cata = new Contact username: "cata", observe
# cata.observe (state) ->
#   console.log "   -----> 2/3 <-----", state
# cata.observe (state) ->
#   console.log "    -----> 3/3 <-----", state


# # for index in [1..10]
# #   new Contact username: "user nº#{index}"

# setTimeout =>
#   javi.username += "+"
#   cata.username += "+"
#   javi.destroy()
#   cata.destroy()
# , 100

# return true

# # -- Inline definition
# javi = new Contact
#   username: "Javi", twitter: "@soyjavi", mail: "javi@tapquo.com", since: "1980"
#   , observe
#   , ["add", "update", "delete"]

# # -- 2-steps definition
# date = javi.created_at
# cata = new Contact
#   username: "Cata", twitter: "@cataflu", created_at: date, networks: facebook: false
# cata.observe observe, ["update"]

# # setTimeout =>
# #   new Contact()
# # , 2000

# # # -- No data
# # new Contact()

# # Actions
# javi.name = "Javier"
# javi.since = 1980
# javi.networks = twitter: "@soyjavi"
# javi.fullname = "Francisco Javier"
# delete javi.networks

# setTimeout =>
#   javi.destroy()
# , 2000

# cata.username = "cataflu"
# cata.facebook = undefined
# delete cata.twitter

# # State
# setTimeout =>
#   console.log "-- 1 --"
#   javi.networks = javi.networks or {}
#   javi.networks.skype = "javi.jimenez.villar"
#   # cata.unobserve()
# , 500

# setTimeout =>
#   console.log "-- 2 --"
#   cata.networks.skype = "cataflu"
#   console.log "Contacts.2:", Contact.all()
# , 1000


# setTimeout =>
#   console.log "-- 3 --"
#   # Contact.destroyAll()
#   cata.destroy()
#   console.log "Contacts.3:", Contact.all()
#   console.log "Contacts.34:", Contact.find()
#   instances_with_javi =  Contact.find (instance) -> instance.username is "Javi"
#   console.log "instances_with_javi", instances_with_javi
#   instance.destroy() for instance in instances_with_javi
# , 1500

# # Methods
# console.log "Findby", Contact.findBy "username", "Javier"
