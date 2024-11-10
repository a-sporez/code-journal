In Lua and LÖVE 2D, there are several ways to structure object-oriented programming (OOP). Here’s a list of common OOP patterns and methods for creating tables and encapsulating functions in their own files:

### 1. **Basic Table with Functions (Module)**
   - **How it works**: A simple Lua module can be a table that holds functions and variables. These can be stored in a separate file and imported with `require`.
   - **Example**: Encapsulating a set of related functions in a table.

```lua
-- /src/my_module.lua
local myModule = {}

function myModule.sayHello()
    print("Hello from myModule!")
end

return myModule
```

   - **Usage**:
```lua
-- main.lua
local myModule = require("src.my_module")
myModule.sayHello()
```

### 2. **Metatables with OOP (Prototype-based OOP)**
   - **How it works**: Lua uses metatables to simulate classes and inheritance. You define a table as your "class" and create instances of it using `setmetatable`.
   - **Example**: Using metatables to define an object and its methods.

```lua
-- /src/my_class.lua
local MyClass = {}
MyClass.__index = MyClass

function MyClass.new(name)
    local self = setmetatable({}, MyClass)
    self.name = name
    return self
end

function MyClass:speak()
    print("Hello, my name is " .. self.name)
end

return MyClass
```

   - **Usage**:
```lua
-- main.lua
local MyClass = require("src.my_class")
local obj = MyClass.new("Alice")
obj:speak()
```

### 3. **Class-based OOP using Libraries**
   - **How it works**: Lua doesn't have built-in classes, but you can use libraries like [30log](https://github.com/Yonaba/30log) or [middleclass](https://github.com/kikito/middleclass) to implement a more traditional class-based OOP system.
   - **Example**: Using the `30log` library.

```lua
-- /src/my_class.lua
local class = require('30log')
local MyClass = class("MyClass")

function MyClass:init(name)
    self.name = name
end

function MyClass:speak()
    print("Hello, my name is " .. self.name)
end

return MyClass
```

   - **Usage**:
```lua
-- main.lua
local MyClass = require("src.my_class")
local obj = MyClass("Alice")
obj:speak()
```

### 4. **Object Factory Pattern**
   - **How it works**: This pattern involves creating functions that return new tables (objects). This can be simpler than full OOP when you don’t need inheritance.
   - **Example**: Object factory to create instances.

```lua
-- /src/crew_member.lua
local function CrewMember(name, department)
    return {
        name = name,
        department = department,
        speak = function(self)
            print("Hello, I work in the " .. self.department)
        end
    }
end

return CrewMember
```

   - **Usage**:
```lua
-- main.lua
local CrewMember = require("src.crew_member")
local crew = CrewMember("Bob", "engineering")
crew:speak()
```

### 5. **Table with Closures (Functional OOP)**
   - **How it works**: You can use closures (functions that capture local variables) to create private state for objects.
   - **Example**: Using closures for encapsulation.

```lua
-- /src/timer.lua
local function Timer()
    local time = 0
    return {
        update = function(self, dt)
            time = time + dt
        end,
        getTime = function()
            return time
        end
    }
end

return Timer
```

   - **Usage**:
```lua
-- main.lua
local Timer = require("src.timer")
local timer = Timer()
timer:update(1)
print(timer:getTime()) -- 1
```

### 6. **Inheritance with Metatables**
   - **How it works**: Using metatables, you can create "subclasses" by setting one table as the metatable for another, effectively inheriting its methods.
   - **Example**: Inheriting behavior between objects.

```lua
-- /src/animal.lua
local Animal = {}
Animal.__index = Animal

function Animal.new(name)
    local self = setmetatable({}, Animal)
    self.name = name
    return self
end

function Animal:speak()
    print("I am an animal.")
end

-- /src/dog.lua
local Dog = {}
Dog.__index = Dog
setmetatable(Dog, {__index = Animal}) -- Dog inherits from Animal

function Dog.new(name)
    local self = setmetatable(Animal.new(name), Dog)
    return self
end

function Dog:speak()
    print("Woof! My name is " .. self.name)
end

return Dog
```

   - **Usage**:
```lua
-- main.lua
local Dog = require("src.dog")
local dog = Dog.new("Rover")
dog:speak() -- Woof! My name is Rover
```

### 7. **Singletons**
   - **How it works**: You can create singleton objects by defining a table with all the necessary methods and returning the same instance every time it's required.
   - **Example**: A singleton module.

```lua
-- /src/game_manager.lua
local GameManager = {
    score = 0
}

function GameManager:addScore(points)
    self.score = self.score + points
end

return GameManager
```

   - **Usage**:
```lua
-- main.lua
local GameManager = require("src.game_manager")
GameManager:addScore(10)
print(GameManager.score) -- 10
```

### Summary of Methods:
1. **Basic Table with Functions**: Simple module with a set of functions and variables.
2. **Metatables with OOP**: Simulate class-based OOP with metatables.
3. **Class-based OOP using Libraries**: Use external libraries like 30log or middleclass for a more formal OOP structure.
4. **Object Factory Pattern**: Create objects using a factory function that returns a table.
5. **Table with Closures**: Use closures for encapsulated state within objects.
6. **Inheritance with Metatables**: Create objects that inherit behavior from other objects.
7. **Singletons**: A single instance of a module or object accessible across your game.

# EXPLORING FURTHER INTO METATABLES

### Overview of Metatables with OOP

In Lua, metatables allow you to give tables special behaviors, such as simulating object-oriented features. Here’s how we can leverage metatables to create classes and objects with methods.

### Key Steps for Metatable OOP:
1. **Create a class table**: This table holds your class methods and data.
2. **Define an object constructor**: A `new()` function that returns an instance (object) of the class.
3. **Use `setmetatable()`**: Attach the class table as the metatable for the instance, enabling method lookup and inheritance.
4. **Define methods**: Create functions that act as methods for your object.
5. **Use `self`**: This is a convention to refer to the instance inside methods.

### Example: Basic Class with Metatables

Let's create a simple class `CrewMember` using metatables.

#### Step-by-Step Breakdown:

1. **Define the class (`CrewMember`)**: The class will have a name and department, and a method for speaking.

```lua
-- /src/crew_member.lua
local CrewMember = {}
CrewMember.__index = CrewMember  -- This defines the lookup behavior for instances

-- Constructor function
function CrewMember.new(name, department)
    local self = setmetatable({}, CrewMember) -- Create a new object and set its metatable to CrewMember
    self.name = name
    self.department = department
    return self
end

-- Method for speaking
function CrewMember:speak()
    print("Hi, my name is " .. self.name .. " and I work in " .. self.department .. ".")
end

return CrewMember
```

- **CrewMember.new()**: This is the constructor function, which creates a new instance of `CrewMember`. It uses `setmetatable()` to link the instance (`self`) to the `CrewMember` class.
- **CrewMember:speak()**: The colon (`:`) syntax automatically passes the instance (`self`) as the first argument, allowing you to access its properties.

#### Usage in `main.lua`:

```lua
-- main.lua
local CrewMember = require("src.crew_member")

-- Create two crew members
local alice = CrewMember.new("Alice", "Engineering")
local bob = CrewMember.new("Bob", "Medical")

-- Call methods
alice:speak()  -- Output: Hi, my name is Alice and I work in Engineering.
bob:speak()    -- Output: Hi, my name is Bob and I work in Medical.
```

Here’s what happens:
- `CrewMember.new("Alice", "Engineering")` creates an instance of `CrewMember`, sets the `name` and `department`, and attaches the class's metatable to the object.
- When you call `alice:speak()`, Lua looks up the `speak` method in the `CrewMember` metatable (because of `__index`), finds it, and calls it with `alice` as `self`.

### Adding More Features

You can expand this further by adding more methods or creating subclass-like behavior by reusing metatables.

#### Example: Adding More Methods

```lua
-- /src/crew_member.lua
local CrewMember = {}
CrewMember.__index = CrewMember

-- Constructor
function CrewMember.new(name, department)
    local self = setmetatable({}, CrewMember)
    self.name = name
    self.department = department
    self.energy = 100 -- Add energy as a property
    return self
end

-- Method for speaking
function CrewMember:speak()
    print("Hi, my name is " .. self.name .. " and I work in " .. self.department .. ".")
end

-- Method for working, which drains energy
function CrewMember:work()
    if self.energy > 0 then
        self.energy = self.energy - 10
        print(self.name .. " is working! Energy left: " .. self.energy)
    else
        print(self.name .. " is too tired to work.")
    end
end

-- Method to rest and regain energy
function CrewMember:rest()
    self.energy = self.energy + 20
    print(self.name .. " is resting. Energy restored to: " .. self.energy)
end

return CrewMember
```

Now, you have a `work()` and `rest()` method that alters the `energy` property of each crew member.

#### Usage:

```lua
-- main.lua
local CrewMember = require("src.crew_member")

local alice = CrewMember.new("Alice", "Engineering")

alice:speak()
alice:work()  -- Output: Alice is working! Energy left: 90
alice:work()  -- Output: Alice is working! Energy left: 80
alice:rest()  -- Output: Alice is resting. Energy restored to: 100
```

### Inheritance with Metatables

You can simulate inheritance by creating another class that uses the `CrewMember` as a base class.

#### Example: Creating a Subclass

Let’s say we want to create a subclass `Engineer` that inherits from `CrewMember`.

```lua
-- /src/engineer.lua
local Engineer = {}
Engineer.__index = Engineer
setmetatable(Engineer, {__index = CrewMember}) -- Inherit from CrewMember

-- Constructor
function Engineer.new(name)
    local self = setmetatable(CrewMember.new(name, "Engineering"), Engineer)
    return self
end

-- Engineer-specific method
function Engineer:repair()
    print(self.name .. " is repairing the ship!")
end

return Engineer
```

- **Inheritance**: By setting `Engineer`’s metatable to `{__index = CrewMember}`, any method not found in `Engineer` will be looked up in `CrewMember`.

#### Usage:

```lua
-- main.lua
local Engineer = require("src.engineer")

local bob = Engineer.new("Bob")

bob:speak()    -- Output: Hi, my name is Bob and I work in Engineering.
bob:repair()   -- Output: Bob is repairing the ship!
bob:work()     -- Output: Bob is working! Energy left: 90
```

In this case, `Engineer` inherits all the methods from `CrewMember` and adds its own `repair()` method.

### Summary

With metatables, Lua allows you to implement OOP in a flexible way:
1. **`__index` Metamethod**: Used for method lookups in the "class" (table).
2. **`new()` Constructor**: Instantiates new objects and assigns them a metatable.
3. **Inheritance**: Achieved by linking the `__index` metamethod of a subclass to the parent class.

This method is efficient for projects that require object management without using external libraries. Let me know if you need further clarification or examples!

# **_FACTORY PATTERN_**

The **Object Factory Pattern** in Lua is a simple and flexible way to create objects without the complexity of inheritance or metatables. It's particularly useful when you need to create multiple instances of objects with shared behavior, and you don’t need the full complexity of OOP, such as inheritance.

The idea is to create a factory function that returns a new instance of an object (a table), with its properties and methods defined inside that function. This pattern is ideal for lightweight object creation, where each object is a table with its own set of properties and methods.

### Key Steps for Object Factory Pattern:
1. **Define a factory function**: This function creates and returns a new instance (table) with the necessary properties.
2. **Attach methods directly**: Methods are attached to the table as functions that operate on the object's properties.
3. **Return the object**: The function returns the table that represents the object.

### Example: Basic Object Factory

Let’s create a simple factory for a `CrewMember` object.

#### Step-by-Step Breakdown:

1. **Define the factory function**: In this case, `CrewMember()` will be the factory function that creates a new crew member with a name, department, and some methods.

```lua
-- /src/crew_member.lua
local function CrewMember(name, department)
    local self = {
        name = name,
        department = department,
        energy = 100 -- Default energy level
    }

    -- Method for speaking
    function self:speak()
        print("Hi, my name is " .. self.name .. " and I work in " .. self.department .. ".")
    end

    -- Method for working, which drains energy
    function self:work()
        if self.energy > 0 then
            self.energy = self.energy - 10
            print(self.name .. " is working! Energy left: " .. self.energy)
        else
            print(self.name .. " is too tired to work.")
        end
    end

    -- Method for resting, which restores energy
    function self:rest()
        self.energy = self.energy + 20
        print(self.name .. " is resting. Energy restored to: " .. self.energy)
    end

    return self
end

return CrewMember
```

Here’s what’s happening:
- The `CrewMember()` function creates a new table (`self`) to represent a crew member.
- It assigns properties like `name`, `department`, and `energy` to the table.
- It attaches methods directly to the table: `speak()`, `work()`, and `rest()`.
- Finally, it returns the `self` table, which now represents a crew member object with all its methods and properties.

#### Usage in `main.lua`:

```lua
-- main.lua
local CrewMember = require("src.crew_member")

-- Create two crew members using the factory function
local alice = CrewMember("Alice", "Engineering")
local bob = CrewMember("Bob", "Medical")

-- Call methods on each crew member
alice:speak()   -- Output: Hi, my name is Alice and I work in Engineering.
bob:speak()     -- Output: Hi, my name is Bob and I work in Medical.

alice:work()    -- Output: Alice is working! Energy left: 90
alice:work()    -- Output: Alice is working! Energy left: 80
alice:rest()    -- Output: Alice is resting. Energy restored to: 100
```

Here, `CrewMember("Alice", "Engineering")` returns a table representing the crew member Alice. You can call methods like `speak()` and `work()` on this table.

### Extending the Object Factory Pattern

The Object Factory pattern can be extended easily by adding more methods or by using closures to encapsulate private data.

#### Example: Adding More Properties and Methods

Let’s add more properties, such as `task` and `assignTask()` to give crew members tasks.

```lua
-- /src/crew_member.lua
local function CrewMember(name, department)
    local self = {
        name = name,
        department = department,
        energy = 100,
        task = nil -- No task assigned initially
    }

    function self:speak()
        print("Hi, my name is " .. self.name .. " and I work in " .. self.department .. ".")
    end

    function self:work()
        if self.task then
            if self.energy > 0 then
                self.energy = self.energy - 10
                print(self.name .. " is working on " .. self.task .. "! Energy left: " .. self.energy)
            else
                print(self.name .. " is too tired to work.")
            end
        else
            print(self.name .. " has no task assigned.")
        end
    end

    function self:assignTask(task)
        self.task = task
        print(self.name .. " has been assigned to " .. task .. ".")
    end

    function self:rest()
        self.energy = self.energy + 20
        print(self.name .. " is resting. Energy restored to: " .. self.energy)
    end

    return self
end

return CrewMember
```

Now, the `CrewMember` object has an additional `task` property, and methods to assign a task (`assignTask()`) and work on the task (`work()`).

#### Usage in `main.lua`:

```lua
-- main.lua
local CrewMember = require("src.crew_member")

local alice = CrewMember("Alice", "Engineering")

alice:speak()           -- Output: Hi, my name is Alice and I work in Engineering.
alice:assignTask("Fix the reactor")  -- Output: Alice has been assigned to Fix the reactor.
alice:work()            -- Output: Alice is working on Fix the reactor! Energy left: 90
```

### Using Closures for Encapsulation

If you want to encapsulate certain data (make it private), you can use closures to hide specific properties.

#### Example: Private Data Using Closures

Let’s modify the `CrewMember` factory to encapsulate `energy` as private data. The crew member object will still be able to work and rest, but the `energy` property won’t be directly accessible.

```lua
-- /src/crew_member.lua
local function CrewMember(name, department)
    local energy = 100 -- This is now private, not accessible directly from outside

    local self = {
        name = name,
        department = department,
        task = nil
    }

    function self:speak()
        print("Hi, my name is " .. self.name .. " and I work in " .. self.department .. ".")
    end

    function self:work()
        if self.task then
            if energy > 0 then
                energy = energy - 10
                print(self.name .. " is working on " .. self.task .. "! Energy left: " .. energy)
            else
                print(self.name .. " is too tired to work.")
            end
        else
            print(self.name .. " has no task assigned.")
        end
    end

    function self:rest()
        energy = energy + 20
        print(self.name .. " is resting. Energy restored to: " .. energy)
    end

    function self:getEnergy()
        return energy
    end

    return self
end

return CrewMember
```

Here, `energy` is encapsulated inside the `CrewMember` factory function and cannot be accessed or modified directly from outside the object. However, the `work()`, `rest()`, and `getEnergy()` methods can still interact with it.

#### Usage:

```lua
-- main.lua
local CrewMember = require("src.crew_member")

local alice = CrewMember("Alice", "Engineering")

alice:speak()           -- Output: Hi, my name is Alice and I work in Engineering.
alice:assignTask("Fix the reactor") -- Output: Alice has been assigned to Fix the reactor.
alice:work()            -- Output: Alice is working on Fix the reactor! Energy left: 90
alice:rest()            -- Output: Alice is resting. Energy restored to: 110
print(alice:getEnergy()) -- Output: 110 (Energy can be retrieved via a method)
```

### Summary of Object Factory Pattern

The **Object Factory Pattern** is a flexible and lightweight way to create objects without using the complexity of metatables or inheritance. The key features are:
1. **Factory Function**: A function that returns a new object (table) with properties and methods.
2. **Encapsulation**: Data can be encapsulated using closures to create private properties.
3. **Extensibility**: You can easily add new properties and methods to the objects by modifying the factory function.
4. **Simplified Object Creation**: Ideal for games where you need simple objects like game entities, characters, or items.

This pattern is particularly useful in idler or simulation games, where you need multiple similar entities (e.g., crew members, tasks, resources).

# **_INHERITANCE_**

### Key Concepts of Inheritance with Metatables

1. **Base Class (Parent Class)**: A class that defines common behavior (methods) and properties.
2. **Subclass (Child Class)**: A class that inherits behavior from a parent class but can also define its own methods or override parent methods.
3. **Metatables**: Tables that allow Lua to define how certain operations are handled, such as method lookup using the `__index` metamethod.

With inheritance, a subclass will automatically look up methods in its parent class if they are not defined in the subclass itself.

### Example: Base Class and Subclass with Inheritance

Let’s build a **CrewMember** base class and an **Engineer** subclass that inherits from it.

#### Step-by-Step Breakdown

1. **Define the Base Class (`CrewMember`)**:
    - The base class will handle common properties like `name` and `department`, and provide common methods like `speak()`.
2. **Define the Subclass (`Engineer`)**:
    - The subclass inherits from `CrewMember` and adds a specific method, `repair()`, which is only available to engineers.
3. **Use `setmetatable` and `__index`**: This establishes the inheritance relationship between `Engineer` and `CrewMember`.

#### Base Class: `CrewMember`

```lua
-- /src/crew_member.lua
local CrewMember = {}
CrewMember.__index = CrewMember  -- Setting __index for method lookup

-- Constructor for the CrewMember class
function CrewMember.new(name, department)
    local self = setmetatable({}, CrewMember)
    self.name = name
    self.department = department
    self.energy = 100 -- Default energy level
    return self
end

-- Method to speak (common to all crew members)
function CrewMember:speak()
    print("Hi, I'm " .. self.name .. " from " .. self.department .. " department.")
end

-- Method to work (common to all crew members)
function CrewMember:work()
    if self.energy > 0 then
        self.energy = self.energy - 10
        print(self.name .. " is working. Energy left: " .. self.energy)
    else
        print(self.name .. " is too tired to work.")
    end
end

-- Method to rest (common to all crew members)
function CrewMember:rest()
    self.energy = self.energy + 20
    print(self.name .. " is resting. Energy restored to: " .. self.energy)
end

return CrewMember
```

In this base class, `CrewMember` objects have properties like `name`, `department`, and `energy`, and common methods such as `speak()`, `work()`, and `rest()`.

#### Subclass: `Engineer`

Now, let’s define a subclass `Engineer` that inherits from `CrewMember` and adds a special `repair()` method.

```lua
-- /src/engineer.lua
local CrewMember = require("src.crew_member")  -- Import the base class

local Engineer = {}
Engineer.__index = Engineer
setmetatable(Engineer, {__index = CrewMember})  -- Inheritance: Engineer "inherits" from CrewMember

-- Constructor for the Engineer class
function Engineer.new(name)
    local self = setmetatable(CrewMember.new(name, "Engineering"), Engineer)
    return self
end

-- Method specific to engineers
function Engineer:repair()
    if self.energy > 0 then
        print(self.name .. " is repairing the ship!")
    else
        print(self.name .. " is too tired to repair the ship.")
    end
end

return Engineer
```

### Key Points:
- **setmetatable(Engineer, {__index = CrewMember})**: This ensures that when Lua cannot find a method in `Engineer`, it will look for it in `CrewMember`. This is how inheritance works in Lua.
- The `Engineer.new()` constructor first calls `CrewMember.new()` to initialize the base class properties and then returns the engineer instance.

#### Usage in `main.lua`:

```lua
-- main.lua
local Engineer = require("src.engineer")

-- Create an Engineer
local bob = Engineer.new("Bob")

bob:speak()   -- Output: Hi, I'm Bob from Engineering department.
bob:work()    -- Output: Bob is working. Energy left: 90
bob:repair()  -- Output: Bob is repairing the ship!
bob:rest()    -- Output: Bob is resting. Energy restored to: 110
```

Here’s what’s happening:
- **Method Lookup**: When `bob:speak()` is called, Lua looks in the `Engineer` class first, and since `speak()` is not defined there, it checks the `CrewMember` class (due to `__index` inheritance).
- **Subclass-Specific Method**: `bob:repair()` is only available to `Engineer` objects, and it doesn’t affect other crew members like a `Doctor` class would.

### Method Overriding in Subclasses

You can also **override** methods in the subclass. For example, if you want engineers to have a specialized `work()` method, you can redefine it in the `Engineer` class.

#### Overriding `work()` in `Engineer`

```lua
-- /src/engineer.lua
local CrewMember = require("src.crew_member")

local Engineer = {}
Engineer.__index = Engineer
setmetatable(Engineer, {__index = CrewMember})

function Engineer.new(name)
    local self = setmetatable(CrewMember.new(name, "Engineering"), Engineer)
    return self
end

-- Override the work method
function Engineer:work()
    if self.energy > 0 then
        self.energy = self.energy - 15 -- Engineers lose more energy while working
        print(self.name .. " is working on complex engineering tasks! Energy left: " .. self.energy)
    else
        print(self.name .. " is too tired for heavy engineering work.")
    end
end

-- Engineer-specific method
function Engineer:repair()
    if self.energy > 0 then
        print(self.name .. " is repairing the ship!")
    else
        print(self.name .. " is too tired to repair the ship.")
    end
end

return Engineer
```

Now, the `work()` method for engineers consumes more energy compared to the base `CrewMember` class.

#### Usage:

```lua
-- main.lua
local Engineer = require("src.engineer")

local bob = Engineer.new("Bob")

bob:speak()   -- Output: Hi, I'm Bob from Engineering department.
bob:work()    -- Output: Bob is working on complex engineering tasks! Energy left: 85
bob:repair()  -- Output: Bob is repairing the ship!
```

### Multiple Levels of Inheritance

You can also create multiple levels of inheritance. For example, you could have a `SpecialistEngineer` subclass that inherits from `Engineer`.

#### Example: `SpecialistEngineer` Class

```lua
-- /src/specialist_engineer.lua
local Engineer = require("src.engineer")

local SpecialistEngineer = {}
SpecialistEngineer.__index = SpecialistEngineer
setmetatable(SpecialistEngineer, {__index = Engineer})

function SpecialistEngineer.new(name, specialty)
    local self = setmetatable(Engineer.new(name), SpecialistEngineer)
    self.specialty = specialty
    return self
end

-- Override the repair method
function SpecialistEngineer:repair()
    if self.energy > 0 then
        print(self.name .. " is repairing the ship using advanced " .. self.specialty .. " skills!")
    else
        print(self.name .. " is too tired to repair with " .. self.specialty .. ".")
    end
end

return SpecialistEngineer
```

- Here, `SpecialistEngineer` inherits all the methods from `Engineer` but overrides the `repair()` method to specialize the repair process based on a specific field of expertise.

#### Usage:

```lua
-- main.lua
local SpecialistEngineer = require("src.specialist_engineer")

local alice = SpecialistEngineer.new("Alice", "AI systems")

alice:speak()       -- Output: Hi, I'm Alice from Engineering department.
alice:repair()      -- Output: Alice is repairing the ship using advanced AI systems skills!
alice:work()        -- Output: Alice is working on complex engineering tasks! Energy left: 85
```

### Inheritance Summary

1. **Base Class (CrewMember)**: Defines common properties and methods shared by all crew members.
2. **Subclass (Engineer)**: Inherits from the base class and adds new methods or overrides existing ones.
3. **Metatables**: The `__index` metamethod in the subclass points to the base class to enable inheritance.
4. **Method Overriding**: Subclasses can override methods of the base class to provide specialized behavior.
5. **Multiple Inheritance Levels**: You can create more specific subclasses by chaining the `setmetatable` pattern further.

This approach allows you to build a hierarchy of game entities with shared functionality while also giving each subclass specific behaviors. It's especially useful in more complex simulations, such as starship crew management, where different crew roles may have different capabilities.

# **_OOP WITH LIBRARIES_**

Since Lua doesn't have built-in class structures, several libraries have been created to mimic class-based OOP, making it easier to manage objects, inheritance, and encapsulation. Some popular libraries for class-based OOP in Lua include:

1. **MiddleClass** - A lightweight, simple, and widely-used class library.
2. **30log** - A minimal, no-dependency class library.
3. **Classic** - Another small library used by many LÖVE developers.
   
Let's explore each library, focusing on how they handle **classes**, **inheritance**, and **object creation**.

### 1. **MiddleClass**

MiddleClass is simple and intuitive, offering features like inheritance and method overriding.

#### Installation
You can add MiddleClass to your project by downloading the `middleclass.lua` file and placing it in your project directory. You can find it on [GitHub](https://github.com/kikito/middleclass).

#### Usage: Defining a Class

Here’s how to define and use classes with MiddleClass:

```lua
-- /src/crew_member.lua
local class = require("middleclass")  -- Require the middleclass library

-- Define a CrewMember class
local CrewMember = class("CrewMember")

-- Constructor for CrewMember
function CrewMember:initialize(name, department)
    self.name = name
    self.department = department
    self.energy = 100
end

-- Speak method (common to all crew members)
function CrewMember:speak()
    print("Hi, I'm " .. self.name .. " from the " .. self.department .. " department.")
end

-- Work method (common to all crew members)
function CrewMember:work()
    if self.energy > 0 then
        self.energy = self.energy - 10
        print(self.name .. " is working. Energy left: " .. self.energy)
    else
        print(self.name .. " is too tired to work.")
    end
end

-- Rest method (common to all crew members)
function CrewMember:rest()
    self.energy = self.energy + 20
    print(self.name .. " is resting. Energy restored to: " .. self.energy)
end

return CrewMember
```

#### Inheritance with MiddleClass

Let’s create an `Engineer` class that inherits from `CrewMember`.

```lua
-- /src/engineer.lua
local class = require("middleclass")
local CrewMember = require("src.crew_member")

-- Define the Engineer class that inherits from CrewMember
local Engineer = class("Engineer", CrewMember)

-- Constructor for Engineer
function Engineer:initialize(name)
    -- Call the parent constructor
    CrewMember.initialize(self, name, "Engineering")
end

-- New method specific to Engineer
function Engineer:repair()
    if self.energy > 0 then
        print(self.name .. " is repairing the ship!")
    else
        print(self.name .. " is too tired to repair.")
    end
end

return Engineer
```

#### Example of Usage in `main.lua`:

```lua
-- main.lua
local Engineer = require("src.engineer")

local engineer = Engineer:new("Bob")

engineer:speak()  -- Hi, I'm Bob from the Engineering department.
engineer:work()   -- Bob is working. Energy left: 90
engineer:repair() -- Bob is repairing the ship!
```

#### Key Points:
- **Inheritance**: The `Engineer` class inherits from `CrewMember`, allowing it to use all methods from `CrewMember` unless overridden.
- **`:new()` vs `:initialize()`**: `new()` is automatically generated by MiddleClass and calls the `initialize()` method to set up the object.

### 2. **30log**

**30log** is another popular class-based library for Lua. It’s even more lightweight than MiddleClass.

#### Installation
Like MiddleClass, 30log is a single Lua file that can be downloaded from [GitHub](https://github.com/Yonaba/30log).

#### Usage: Defining a Class

```lua
-- /src/crew_member.lua
local class = require("30log")

-- Define a CrewMember class
local CrewMember = class("CrewMember")

-- Constructor for CrewMember
function CrewMember:init(name, department)
    self.name = name
    self.department = department
    self.energy = 100
end

-- Speak method (common to all crew members)
function CrewMember:speak()
    print("Hi, I'm " .. self.name .. " from the " .. self.department .. " department.")
end

-- Work method (common to all crew members)
function CrewMember:work()
    if self.energy > 0 then
        self.energy = self.energy - 10
        print(self.name .. " is working. Energy left: " .. self.energy)
    else
        print(self.name .. " is too tired to work.")
    end
end

return CrewMember
```

#### Inheritance with 30log

```lua
-- /src/engineer.lua
local class = require("30log")
local CrewMember = require("src.crew_member")

-- Define an Engineer class that inherits from CrewMember
local Engineer = CrewMember:extend("Engineer")

-- Constructor for Engineer
function Engineer:init(name)
    Engineer.super.init(self, name, "Engineering") -- Call the parent constructor
end

-- New method specific to Engineer
function Engineer:repair()
    if self.energy > 0 then
        print(self.name .. " is repairing the ship!")
    else
        print(self.name .. " is too tired to repair.")
    end
end

return Engineer
```

#### Example of Usage in `main.lua`:

```lua
-- main.lua
local Engineer = require("src.engineer")

local engineer = Engineer:new("Alice")

engineer:speak()  -- Hi, I'm Alice from the Engineering department.
engineer:work()   -- Alice is working. Energy left: 90
engineer:repair() -- Alice is repairing the ship!
```

#### Key Points:
- **Method Overriding**: You can override methods in the subclass just like with MiddleClass.
- **`:extend()`**: Used to create a subclass in 30log.
- **`:init()`**: Constructor in 30log is typically `init()` rather than `initialize()`.

### 3. **Classic**

**Classic** is a minimal class library often used in the LÖVE community. It’s simple but gets the job done.

#### Installation
You can find Classic on [GitHub](https://github.com/rxi/classic).

#### Usage: Defining a Class

```lua
-- /src/crew_member.lua
local Object = require("classic")  -- Classic uses `Object` as the base

local CrewMember = Object:extend()

-- Constructor for CrewMember
function CrewMember:new(name, department)
    self.name = name
    self.department = department
    self.energy = 100
end

-- Speak method (common to all crew members)
function CrewMember:speak()
    print("Hi, I'm " .. self.name .. " from the " .. self.department .. " department.")
end

-- Work method (common to all crew members)
function CrewMember:work()
    if self.energy > 0 then
        self.energy = self.energy - 10
        print(self.name .. " is working. Energy left: " .. self.energy)
    else
        print(self.name .. " is too tired to work.")
    end
end

return CrewMember
```

#### Inheritance with Classic

```lua
-- /src/engineer.lua
local CrewMember = require("src.crew_member")

-- Define Engineer class that inherits from CrewMember
local Engineer = CrewMember:extend()

-- Constructor for Engineer
function Engineer:new(name)
    Engineer.super.new(self, name, "Engineering") -- Call parent constructor
end

-- New method specific to Engineer
function Engineer:repair()
    if self.energy > 0 then
        print(self.name .. " is repairing the ship!")
    else
        print(self.name .. " is too tired to repair.")
    end
end

return Engineer
```

#### Example of Usage in `main.lua`:

```lua
-- main.lua
local Engineer = require("src.engineer")

local engineer = Engineer("Bob")

engineer:speak()  -- Hi, I'm Bob from the Engineering department.
engineer:work()   -- Bob is working. Energy left: 90
engineer:repair() -- Bob is repairing the ship!
```

#### Key Points:
- **`:new()` and `:extend()`**: Classic uses `new()` as the constructor and `extend()` for inheritance.
- **Minimalistic**: Classic is very lightweight and closer to Lua's "DIY" style.

### Comparison of Libraries

| Feature              | MiddleClass             | 30log                  | Classic             |
|----------------------|-------------------------|------------------------|---------------------|
| **Inheritance**       | `class("Name", Parent)` | `BaseClass:extend()`    | `Object:extend()`    |
| **Method Overriding** | Supported               | Supported               | Supported            |
| **Constructor**       | `initialize()`          | `init()`                | `new()`              |
| **Simplicity**        | Easy to use             | Lightweight and minimal | Very minimal         |
| **Use in LÖVE 2D**    | Commonly used           | Commonly used           | Common in LÖVE       |

### Summary

- **MiddleClass** is a good balance between functionality and simplicity, making it an excellent choice for beginners

.
- **30log** is minimalistic and super lightweight, suitable for those looking for a less-featured class system.
- **Classic** is small and frequently used in the LÖVE community due to its simplicity and alignment with Lua's style.

# **_TABLE WITH CLOSURE_**

This technique involves defining a table where each key is associated with a function, and closures are used to store private data, giving control over what is accessible from outside the "object."

Let's explore how to implement **table with closure** OOP.

### How Closures Work

A **closure** in Lua is a function that "closes over" the variables in its enclosing scope. These variables remain accessible even after the scope in which they were declared has finished executing. This property makes closures useful for creating private data in Lua.

### Example: Crew Member Object Using Table with Closure

We'll create a `CrewMember` object with private data and methods using closures.

```lua
-- /src/crew_member.lua
local function CrewMember(name, department)
    -- Private variables
    local energy = 100

    -- Public methods exposed in a table
    local crewMember = {}

    -- Speak method
    function crewMember.speak()
        print("Hi, I'm " .. name .. " from the " .. department .. " department.")
    end

    -- Work method
    function crewMember.work()
        if energy > 0 then
            energy = energy - 10
            print(name .. " is working. Energy left: " .. energy)
        else
            print(name .. " is too tired to work.")
        end
    end

    -- Rest method
    function crewMember.rest()
        energy = energy + 20
        print(name .. " is resting. Energy restored to: " .. energy)
    end

    -- Getter for energy (optional, if you want to expose it)
    function crewMember.getEnergy()
        return energy
    end

    -- Return the table with public methods
    return crewMember
end

return CrewMember
```

#### Explanation:
- **Private data**: `energy` is only accessible within the closure.
- **Public methods**: These are returned as part of the `crewMember` table, allowing external access to specific functionality like `speak()`, `work()`, and `rest()`.
- **Encapsulation**: The name and department are captured by the closure, and `energy` is kept private, while still allowing the object to manipulate it internally.

### Inheritance with Closures

Inheritance can also be mimicked using closures, though it requires a bit of manual work since we aren't using metatables or class-based libraries. Let's extend the `CrewMember` to create an `Engineer`.

```lua
-- /src/engineer.lua
local function Engineer(name)
    -- Create a CrewMember object
    local crewMember = require("src.crew_member")(name, "Engineering")

    -- Extend it with new methods specific to Engineer
    function crewMember.repair()
        if crewMember.getEnergy() > 0 then
            print(name .. " is repairing the ship!")
        else
            print(name .. " is too tired to repair.")
        end
    end

    -- Return the extended object
    return crewMember
end

return Engineer
```

#### Explanation:
- The `Engineer` object extends the functionality of `CrewMember` by adding a `repair()` method.
- The existing `CrewMember` methods and private data (like `energy`) are reused inside the `Engineer` object through closures.
- **Encapsulation is maintained**: The `energy` variable is still private and cannot be accessed directly outside the object.

### Example Usage in `main.lua`

```lua
-- main.lua
local Engineer = require("src.engineer")

local engineer = Engineer("Alice")

engineer.speak()  -- Hi, I'm Alice from the Engineering department.
engineer.work()   -- Alice is working. Energy left: 90
engineer.repair() -- Alice is repairing the ship!
engineer.rest()   -- Alice is resting. Energy restored to: 110
```

### Key Concepts of Table with Closure:
- **Encapsulation**: Private data is completely hidden from outside access.
- **No metatables**: This method doesn't rely on metatables, making it simpler in some cases.
- **Closure-based privacy**: Variables captured by the closure retain their values even after the function call is completed, keeping them effectively private.
- **Manual inheritance**: Inheritance has to be done manually by combining the parent object’s methods and adding new ones.

### Advantages:
1. **Privacy**: Data can be completely private, unlike in Lua's metatable-based OOP where everything is technically accessible.
2. **Simplicity**: No need for metatables or external libraries, relying on Lua’s core functionality.
3. **Control**: You can define exactly what the "object" exposes to the outside world, making it highly customizable.

### Disadvantages:
1. **Manual inheritance**: Inheritance has to be handled manually, which may become complex in larger projects.
2. **Memory**: In some cases, excessive closures might use more memory since each object captures its own variables.

### Extending Further: Multiple Objects Sharing Behavior

To avoid duplicating methods across many objects (especially if there are multiple objects like `CrewMember`s or `Engineer`s), you can place shared methods in a common table and access them via closures. Here's an example:

```lua
-- Shared methods table
local crewMethods = {}

function crewMethods.work(self)
    if self.energy > 0 then
        self.energy = self.energy - 10
        print(self.name .. " is working. Energy left: " .. self.energy)
    else
        print(self.name .. " is too tired to work.")
    end
end

function crewMethods.rest(self)
    self.energy = self.energy + 20
    print(self.name .. " is resting. Energy restored to: " .. self.energy)
end

-- Object creation function
local function CrewMember(name, department)
    local self = {
        name = name,
        department = department,
        energy = 100
    }

    -- Set behavior using shared methods
    return setmetatable(self, { __index = crewMethods })
end

return CrewMember
```

In this example:
- **Shared methods** are stored in a table `crewMethods`.
- Objects (`self`) use the methods via `__index`, saving memory and avoiding method duplication.

# **_SINGLETON_**

The **singleton** pattern is a design pattern where a class or object can only have one instance, ensuring that there’s only a single point of access to certain data or behavior. In Lua, we can implement a singleton in various ways, but the essence remains the same: restrict the instantiation of an object to only one.

In game development, a singleton can be useful for things like managing **game states**, **configuration**, or **audio** (where you don’t want multiple instances controlling settings).

Let's explore how to implement a **singleton** pattern in Lua and LÖVE 2D.

### Key Features of a Singleton
1. **Single Instance**: Only one instance of the object can exist.
2. **Global Access Point**: A global or easily accessible entry point to the object.
3. **Lazy Initialization**: The object is created when it’s first accessed (not before).

### Singleton Implementation

There are several ways to implement a singleton in Lua. Let’s go over the most common ones:

---

### 1. **Basic Singleton with a Local Table**

In this implementation, we use a simple table and ensure that the instance is created only once.

```lua
-- /src/game_manager.lua
local GameManager = {}
GameManager.__index = GameManager

-- Singleton instance (private variable)
local instance = nil

-- Private constructor (local function)
local function new()
    local self = setmetatable({}, GameManager)

    -- Initialize the game manager state
    self.currentLevel = 1
    self.score = 0
    self.paused = false

    return self
end

-- Public method to get the singleton instance
function GameManager.getInstance()
    if not instance then
        instance = new()  -- Create the instance if it doesn't exist
    end
    return instance
end

-- Example public method
function GameManager:resetGame()
    self.currentLevel = 1
    self.score = 0
    self.paused = false
    print("Game reset!")
end

-- Example public method
function GameManager:pause()
    self.paused = true
    print("Game paused.")
end

return GameManager
```

#### Explanation:
- **`instance`**: A local variable that holds the singleton instance.
- **`new()`**: A private constructor that is only called once when `getInstance()` is called for the first time.
- **`getInstance()`**: The public method that either creates the singleton or returns the existing instance.
- **Encapsulation**: Direct instantiation of the object is not possible, ensuring there’s only one instance.

#### Example Usage in `main.lua`:

```lua
-- main.lua
local GameManager = require("src.game_manager")

-- Access the singleton instance
local gameManager = GameManager.getInstance()

-- Use the singleton methods
gameManager:resetGame()  -- Game reset!
gameManager:pause()      -- Game paused.

-- Access the same singleton instance later
local anotherGameManager = GameManager.getInstance()

-- Check if they are the same instance
if gameManager == anotherGameManager then
    print("Same GameManager instance")
end
```

### 2. **Singleton Using Closures**

You can also implement a singleton using closures to encapsulate the object’s state, providing additional privacy.

```lua
-- /src/audio_manager.lua
local function AudioManager()
    -- Private state
    local volume = 100

    -- Singleton instance
    local instance = nil

    -- Public methods
    local manager = {}

    function manager.setVolume(newVolume)
        volume = math.max(0, math.min(newVolume, 100))  -- Clamp between 0 and 100
        print("Volume set to: " .. volume)
    end

    function manager.getVolume()
        return volume
    end

    -- Return a function that ensures only one instance
    return function()
        if not instance then
            instance = manager
        end
        return instance
    end
end

-- Return the function to get the singleton
return AudioManager()
```

#### Explanation:
- **Closure for privacy**: The audio manager’s state (`volume`) is private and cannot be accessed outside the object.
- **Singleton instance**: The closure ensures that the `instance` is only created once.
  
#### Example Usage in `main.lua`:

```lua
-- main.lua
local AudioManager = require("src.audio_manager")

-- Access the singleton instance
local audioManager = AudioManager()

-- Use the singleton methods
audioManager.setVolume(80)    -- Volume set to: 80
print(audioManager.getVolume())  -- 80

-- Access the same singleton instance later
local anotherAudioManager = AudioManager()
print(anotherAudioManager.getVolume())  -- 80

if audioManager == anotherAudioManager then
    print("Same AudioManager instance")
end
```

### 3. **Singleton Using Metatables**

Another approach is to use metatables to enforce the singleton pattern.

```lua
-- /src/config_manager.lua
local ConfigManager = {}
ConfigManager.__index = ConfigManager

-- Singleton instance
local instance = nil

-- Private constructor
local function new()
    local self = setmetatable({}, ConfigManager)

    -- Example configuration data
    self.settings = {
        fullscreen = false,
        resolution = { width = 1920, height = 1080 },
        soundVolume = 50
    }

    return self
end

-- Singleton creation using __call
setmetatable(ConfigManager, {
    __call = function()
        if not instance then
            instance = new()  -- Create instance if not already created
        end
        return instance
    end
})

-- Example public method
function ConfigManager:setFullscreen(isFullscreen)
    self.settings.fullscreen = isFullscreen
    print("Fullscreen set to: " .. tostring(isFullscreen))
end

-- Example public method
function ConfigManager:getResolution()
    return self.settings.resolution
end

return ConfigManager
```

#### Explanation:
- **Metatable `__call`**: By using the `__call` metamethod, we ensure that every time you "call" the `ConfigManager` table, you are accessing the singleton.
- **Private constructor**: `new()` is private, so it cannot be called directly.

#### Example Usage in `main.lua`:

```lua
-- main.lua
local ConfigManager = require("src.config_manager")

-- Access the singleton instance
local configManager = ConfigManager()

-- Use the singleton methods
configManager:setFullscreen(true)   -- Fullscreen set to: true

local resolution = configManager:getResolution()
print("Resolution: " .. resolution.width .. "x" .. resolution.height)

-- Access the same singleton instance later
local anotherConfigManager = ConfigManager()

if configManager == anotherConfigManager then
    print("Same ConfigManager instance")
end
```

### Summary of Singleton Implementations

| Implementation      | Description                                          |
|---------------------|------------------------------------------------------|
| **Local Table**      | Most straightforward, using a local instance and lazy initialization. |
| **Closure**          | Provides better encapsulation of state by using closures. |
| **Metatable `__call`**| Uses metatables to handle singleton access elegantly, enforcing the singleton when calling the table directly. |

### When to Use the Singleton Pattern
- **Global Game Managers**: For systems that need to be accessible globally, like managing game state, configuration, or input handling.
- **Audio or Resource Managers**: For managing shared resources, where you only want one manager responsible for playing sounds or loading assets.
- **Settings**: For storing configuration or settings, especially when those settings affect the whole game.

### Drawbacks of the Singleton Pattern
1. **Global state**: If overused, singletons can lead to tight coupling between different parts of the code, making the project harder to maintain.
2. **Testing difficulty**: Since singletons are global, it can make unit testing more challenging because the same instance persists across tests.