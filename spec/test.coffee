console.log "\n--"

# -- Test

class window.Contact extends Hamsa

Contact.observe (state) -> console.log "Contact.observe", state

observe = (state) -> console.log "#{state.object.name}.observe", state.type, state

javi = new Contact name: "Javi", twitter: "@soyjavi", observe, ["add", "update"]
cata = new Contact name: "Cata", twitter: "@cataflu", networks: facebook: false
cata.observe observe#, ["update"]

# Actions
javi.name = "Javier"
javi.fullname = "Francisco Javier"
delete javi.twitter

cata.name = "Catalina"
cata.facebook = undefined
delete cata.twitter

# State
setTimeout =>
  console.log "-- 1 --"
  javi.skype = "javi.jimenez.villar"
  # cata.unobserve()
, 500

setTimeout =>
  console.log "-- 2 --"
  cata.skype = "cataflu"
  console.log "Contacts:", Contact.all()
, 1000


setTimeout =>
  console.log "-- 3 --"
  Contact.destroyAll()
  console.log "Contacts:", Contact.all()
, 1500

# Methods
console.log "Findby", Contact.findBy "name", "Javier"
