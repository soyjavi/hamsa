console.log "\n--"

# -- Test

class window.Contact extends Hamsa

  @define
    id              : type: String
    mail            : type: String
    username        : type: String
    avatar          : type: String, default: "http://gravatar.org"
    networks        : type: Object
    since           : type: Number, default: 2014
    created_at      : type: Date, default: new Date()

  @fullname: ->
    console.log "???fullname"

Contact.observe (state) -> console.log "Contact.observe", state

observe = (state) -> console.log "#{state.object.username}.observe", state.type, state

# -- Inline definition
javi = new Contact
  username: "Javi", twitter: "@soyjavi", mail: "javi@tapquo.com"
  , observe
  , ["add", "update", "delete"]
# -- 2-steps definition
cata = new Contact
  username: "Cata", twitter: "@cataflu", networks: facebook: false
cata.observe observe, ["update"]
# -- No data
new Contact()

# # Actions
javi.name = "Javier"
javi.since = 1980
javi.networks = twitter: "@soyjavi"
javi.fullname = "Francisco Javier"
delete javi.networks

cata.username = "cataflu"
cata.facebook = undefined
delete cata.twitter

# State
setTimeout =>
  console.log "-- 1 --"
  javi.networks = javi.networks or {}
  javi.networks.skype = "javi.jimenez.villar"
  # cata.unobserve()
, 500

setTimeout =>
  console.log "-- 2 --"
  cata.networks.skype = "cataflu"
  console.log "Contacts.2:", Contact.all()
, 1000


setTimeout =>
  console.log "-- 3 --"
  # Contact.destroyAll()
  cata.destroy()
  console.log "Contacts.3:", Contact.all()
  console.log "Contacts.34:", Contact.find()
  instances_with_javi =  Contact.find (instance) -> instance.username is "Javi"
  console.log "instances_with_javi", instances_with_javi
  instance.destroy() for instance in instances_with_javi
, 1500

# Methods
console.log "Findby", Contact.findBy "username", "Javier"
