# -- Test
class Contact extends Hamsa

Contact.observe (state) -> console.log "Contact.observe", state

observe = (state) -> console.log "#{state.object.name}.observe", state

javi = new Contact name: "Javi", twitter: "@soyjavi", observe, ["add", "delete"]
cata = new Contact name: "Cata", twitter: "@cataflu"
cata.observe observe#, ["update"]

# Actions
javi.fields.name = "Javier"
javi.fields.fullname = "Francisco Javier"
delete javi.fields.twitter

cata.fields.name = "Catalina"
cata.fields.facebook = undefined

# State
setTimeout =>
  console.log "-- 1 --"
  javi.fields.skype = "javi.jimenez.villar"
  # cata.unobserve()
, 500

setTimeout =>
  console.log "-- 2 --"
  cata.fields.skype = "cataflu"
  console.log "Contacts:", Contact.all()
, 1000


setTimeout =>
  console.log "-- 3 --"
  Contact.destroyAll()
  console.log "Contacts:", Contact.all()
, 1500

# Methods
console.log "Findby", Contact.findBy "name", "Javier"
