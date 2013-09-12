Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

Function::getter = (prop, get) ->
  Object.defineProperty @prototype, prop, {get, configurable: yes}

Function::setter = (prop, set) ->
  Object.defineProperty @prototype, prop, {set, configurable: yes}

###
http://stackoverflow.com/questions/11587231/coffeescript-getter-setter-in-object-initializers

To use property:
class Person
  constructor: (@firstName, @lastName) ->
  @property 'fullName',
    get: -> "#{@firstName} #{@lastName}"
    set: (name) -> [@firstName, @lastName] = name.split ' '

p = new Person 'Robert', 'Paulson'
console.log p.fullName # Robert Paulson
p.fullName = 'Space Monkey'
console.log p.lastName # Monkey

or use getter or setter:
class Person
  constructor: (@firstName, @lastName) ->
  @getter 'fullName', -> "#{@firstName} #{@lastName}"
  @setter 'fullName', (name) -> [@firstName, @lastName] = name.split ' '

###