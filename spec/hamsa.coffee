describe "Hamsa", ->

  Contact = undefined
  contact = undefined
  spy     = undefined

  beforeEach ->
    class Contact extends Hamsa
    contact = new Contact name: "Javi", twitter: "@soyjavi"

    noop = spy: -> @
    spyOn noop, "spy"
    spy = noop.spy

  it "can create a new instance", ->
    expect(contact.fields.name).toEqual "Javi"

  it "can find a instance by a determinate field", ->
    contacts = Contact.findBy name: "Javi"
    expect(contacts).toBeTruthy()
    expect(contacts.length).toEqual 2
    expect(contacts[0].name).toEqual "Javi"

  it "can return null if instance isn't exists", ->
    contacts = Contact.findBy "name", "Cata"
    expect(contacts.length).toEqual 0

  it "can return all instances of a determinate Hamsa", ->
    contacts = Contact.all()
    expect(contacts[0]).toEqual contact.fields
    expect(contacts.length).toEqual 4
    new Contact name: "Cata", twitter: "@cataflu"
    new Contact name: "Oihane", twitter: "@oihi08"
    expect(Contact.all().length).toEqual 6

  it "can observe changes in Hamsa Repository", ->
    Contact.observe spy
    new Contact name: "Imanol", twitter: "@cerohistorias"
    expect(spy).toHaveBeenCalled()

  it "can observe changes in a determinate instance", ->
    contact.observe spy
    contact.fields.name "Javier"
    expect(spy).toHaveBeenCalled()

  it "can destroy all instances of a Hamsa Repository", ->
    Contact.destroyAll()
    expect(Contact.all().length).toEqual 0
