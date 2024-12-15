Sure! Here's a **quick reference guide** for working with the **HUMP vector library** (`hump.vector`) that you can keep handy for designing movement and complex positional translations.

---

## **HUMP Vector Quick Reference Guide**

### **1. Basics: Vector Creation**
- Create a vector using the `vector` object:
  ```lua
  local vector = require "hump.vector"
  local v = vector(x, y)
  ```

- Example:
  ```lua
  local v = vector(10, 5)  -- Creates a vector (10, 5)
  ```

---

### **2. Accessing & Modifying Components**
- Access `x` and `y`:
  ```lua
  local x = v.x
  local y = v.y
  ```
- Modify components:
  ```lua
  v.x = 20
  v.y = 10
  ```

---

### **3. Vector Operations**
- **Addition**: Add vectors to combine movements.
  ```lua
  local result = v1 + v2
  ```
- **Subtraction**: Calculate the difference between two vectors.
  ```lua
  local result = v1 - v2
  ```
- **Scalar Multiplication/Division**: Scale or shrink a vector.
  ```lua
  local scaled = v * 2
  local shrunk = v / 2
  ```
- **Negation**: Reverse the direction of a vector.
  ```lua
  local opposite = -v
  ```

---

### **4. Magnitude and Normalization**
- **Magnitude** (Length of the vector):
  ```lua
  local mag = v:len()
  ```
- **Normalize** (Direction with magnitude = 1):
  ```lua
  local unit = v:normalized()
  ```

---

### **5. Rotations**
- **Rotate a vector** by an angle (in radians):
  ```lua
  local rotated = v:rotated(math.pi / 4)  -- Rotate 45 degrees
  ```

- **Angle of a vector**:
  ```lua
  local angle = v:angleTo()
  ```

---

### **6. Dot Product**
- Measures how similar two vectors are in direction.
  ```lua
  local dot = v1:dot(v2)
  ```

---

### **7. Distance Between Two Points**
- Find the distance between two vectors (or points):
  ```lua
  local dist = (v1 - v2):len()
  ```

---

### **8. Perpendicular Vectors**
- **Left-hand perpendicular**:
  ```lua
  local perp = v:perpendicular()
  ```
- **Right-hand perpendicular**:
  ```lua
  local rperp = v:perpendicular(-1)
  ```

---

### **9. Lerp (Linear Interpolation)**
- Interpolate smoothly between two vectors:
  ```lua
  local lerp = v1 * (1 - t) + v2 * t  -- where t is a number between 0 and 1
  ```

---

### **10. Complex Translations**
- Translate by another vector:
  ```lua
  position = position + movement_vector
  ```
- Rotate around a point:
  ```lua
  local offset = vector(x, y)
  local rotated_offset = offset:rotated(angle)
  local new_position = center + rotated_offset
  ```

---

### **11. Example: Simple Movement System**
```lua
local vector = require "hump.vector"

-- Player position and velocity
local position = vector(100, 100)
local velocity = vector(2, 3)  -- Moves right and down

-- Update function
function update(dt)
  position = position + velocity * dt  -- Move based on velocity
end

-- Draw function
function draw()
  love.graphics.circle("fill", position.x, position.y, 10)  -- Draw player
end
```

---

### **12. Debugging Tips**
- Print vector values easily:
  ```lua
  print(v)  -- Outputs: "vector(x, y)"
  ```
- Visualize with LOVE2D:
  ```lua
  love.graphics.line(0, 0, v.x, v.y)  -- Draw the vector as a line
  ```

---

Keep this guide as a reference when designing movement and handling complex positional translations. Let me know if you need any clarification or additional examples! 🚀

Handling **rotation**, **forward/backward movement**, and **strafing** in **Love2D** with **Lua** generally involves combining basic geometry (angles and trigonometry) with vectors. Here's a detailed guide to help you implement these movements:

---

## **1. Understanding Rotation and Movement**

### Coordinate System in LOVE:
- **Origin**: (0, 0) at the top-left corner of the screen.
- **Angle Convention**: 
  - Angles in radians (preferred in Love2D).
  - Positive angles rotate **counterclockwise**.
  - `math.pi` radians = 180°.

---

## **2. Rotating and Moving Forward/Backward**

### **Direction Based Movement**
The direction in which an object is facing is determined by its **rotation angle**. 

#### **Compute Forward Movement:**
To move forward along a facing direction:
```lua
local dx = math.cos(angle) * speed
local dy = math.sin(angle) * speed
```

#### **Move Backward:**
Simply reverse the direction:
```lua
local dx = -math.cos(angle) * speed
local dy = -math.sin(angle) * speed
```

### Example:
```lua
local x, y = 400, 300    -- Object's position
local angle = 0          -- Facing angle (in radians)
local speed = 200        -- Speed in pixels per second

function love.update(dt)
    if love.keyboard.isDown("up") then
        x = x + math.cos(angle) * speed * dt
        y = y + math.sin(angle) * speed * dt
    end

    if love.keyboard.isDown("down") then
        x = x - math.cos(angle) * speed * dt
        y = y - math.sin(angle) * speed * dt
    end

    if love.keyboard.isDown("left") then
        angle = angle - 2 * dt  -- Rotate counterclockwise
    end

    if love.keyboard.isDown("right") then
        angle = angle + 2 * dt  -- Rotate clockwise
    end
end

function love.draw()
    love.graphics.translate(x, y)      -- Move the origin to the object's position
    love.graphics.rotate(angle)       -- Rotate around the origin
    love.graphics.rectangle("fill", -25, -10, 50, 20)  -- Draw a rectangle as the object
end
```

---

## **3. Strafing**

Strafing involves moving **sideways** relative to the facing direction. Use the **perpendicular direction** for this:
```lua
local dx = math.sin(angle) * speed
local dy = -math.cos(angle) * speed
```

### Example:
Add strafing to the previous code:
```lua
if love.keyboard.isDown("a") then  -- Strafe left
    x = x - math.sin(angle) * speed * dt
    y = y + math.cos(angle) * speed * dt
end

if love.keyboard.isDown("d") then  -- Strafe right
    x = x + math.sin(angle) * speed * dt
    y = y - math.cos(angle) * speed * dt
end
```

---

## **4. Combine Forward/Backward and Strafing with Vectors**
Using the **HUMP vector library**, you can simplify these calculations:
```lua
local vector = require "hump.vector"

local position = vector(400, 300)  -- Position of the object
local angle = 0                   -- Facing angle
local speed = 200                 -- Speed

function love.update(dt)
    local movement = vector(0, 0)

    -- Forward/Backward movement
    if love.keyboard.isDown("up") then
        movement = movement + vector(math.cos(angle), math.sin(angle)) * speed * dt
    end
    if love.keyboard.isDown("down") then
        movement = movement - vector(math.cos(angle), math.sin(angle)) * speed * dt
    end

    -- Strafing
    if love.keyboard.isDown("a") then
        movement = movement + vector(-math.sin(angle), math.cos(angle)) * speed * dt
    end
    if love.keyboard.isDown("d") then
        movement = movement + vector(math.sin(angle), -math.cos(angle)) * speed * dt
    end

    -- Update position
    position = position + movement

    -- Rotate
    if love.keyboard.isDown("left") then
        angle = angle - 2 * dt
    end
    if love.keyboard.isDown("right") then
        angle = angle + 2 * dt
    end
end

function love.draw()
    love.graphics.translate(position.x, position.y)
    love.graphics.rotate(angle)
    love.graphics.rectangle("fill", -25, -10, 50, 20)
end
```

---

## **5. Advanced Movement Enhancements**

### **Acceleration and Deceleration**
Add a velocity vector to control smooth starts/stops:
```lua
local velocity = vector(0, 0)
local friction = 0.9  -- Reduce velocity over time

function love.update(dt)
    local acceleration = vector(0, 0)

    -- Add forces based on input
    if love.keyboard.isDown("up") then
        acceleration = acceleration + vector(math.cos(angle), math.sin(angle)) * speed
    end
    if love.keyboard.isDown("down") then
        acceleration = acceleration - vector(math.cos(angle), math.sin(angle)) * speed
    end
    if love.keyboard.isDown("a") then
        acceleration = acceleration + vector(-math.sin(angle), math.cos(angle)) * speed
    end
    if love.keyboard.isDown("d") then
        acceleration = acceleration + vector(math.sin(angle), -math.cos(angle)) * speed
    end

    -- Update velocity and apply friction
    velocity = (velocity + acceleration * dt) * friction

    -- Update position
    position = position + velocity * dt

    -- Rotate
    if love.keyboard.isDown("left") then
        angle = angle - 2 * dt
    end
    if love.keyboard.isDown("right") then
        angle = angle + 2 * dt
    end
end
```

---

## **6. Rotation Around Arbitrary Points**
To rotate around a specific point (e.g., a planet):
```lua
function rotateAroundPoint(px, py, cx, cy, angle)
    local s, c = math.sin(angle), math.cos(angle)
    local dx, dy = px - cx, py - cy
    return cx + dx * c - dy * s, cy + dx * s + dy * c
end
```

---

### **Summary**
- **Forward/Backward**: Use `math.cos` and `math.sin` with the current angle.
- **Strafing**: Move along the perpendicular direction.
- Use **HUMP vectors** to simplify combined movements.
- Add **acceleration/deceleration** for smoother controls.
- Consider rotating around arbitrary points for advanced mechanics.

Let me know if you'd like an example for anything specific! 🚀

Using a **position vector** simplifies your calculations by allowing you to handle movement, rotation, and strafing entirely with vector operations. Here's how to adapt the examples for a position vector:

---

## **1. Core Setup Using Vectors**
You can store the position as a **`vector`** (from the HUMP library), which combines the `x` and `y` coordinates into a single object. Here's a basic setup:

### Example:
```lua
local vector = require "hump.vector"

local position = vector(400, 300)  -- Initial position
local angle = 0                   -- Facing direction in radians
local speed = 200                 -- Movement speed (pixels/second)
```

---

## **2. Forward and Backward Movement**
To move forward or backward, calculate the **direction vector** using the current angle and scale it by the speed and delta time (`dt`).

### Code:
```lua
if love.keyboard.isDown("up") then
    position = position + vector(math.cos(angle), math.sin(angle)) * speed * dt
end

if love.keyboard.isDown("down") then
    position = position - vector(math.cos(angle), math.sin(angle)) * speed * dt
end
```

---

## **3. Strafing (Sideways Movement)**
Strafing uses the **perpendicular direction**:
- Left strafe: Rotate the forward direction 90° counterclockwise.
- Right strafe: Rotate it 90° clockwise.

### Code:
```lua
if love.keyboard.isDown("a") then
    position = position + vector(-math.sin(angle), math.cos(angle)) * speed * dt
end

if love.keyboard.isDown("d") then
    position = position + vector(math.sin(angle), -math.cos(angle)) * speed * dt
end
```

---

## **4. Rotation**
Rotation affects only the **angle**. Use the keyboard input to change the angle, which updates the facing direction.

### Code:
```lua
if love.keyboard.isDown("left") then
    angle = angle - 2 * dt  -- Rotate counterclockwise
end

if love.keyboard.isDown("right") then
    angle = angle + 2 * dt  -- Rotate clockwise
end
```

---

## **5. Full Example: Movement with Vectors**
Here's how all these pieces fit together in a complete example:

```lua
local vector = require "hump.vector"

-- Initial setup
local position = vector(400, 300)  -- Starting position
local angle = 0                   -- Facing direction in radians
local speed = 200                 -- Movement speed (pixels/second)

function love.update(dt)
    -- Forward and backward movement
    if love.keyboard.isDown("up") then
        position = position + vector(math.cos(angle), math.sin(angle)) * speed * dt
    end
    if love.keyboard.isDown("down") then
        position = position - vector(math.cos(angle), math.sin(angle)) * speed * dt
    end

    -- Strafing
    if love.keyboard.isDown("a") then
        position = position + vector(-math.sin(angle), math.cos(angle)) * speed * dt
    end
    if love.keyboard.isDown("d") then
        position = position + vector(math.sin(angle), -math.cos(angle)) * speed * dt
    end

    -- Rotation
    if love.keyboard.isDown("left") then
        angle = angle - 2 * dt
    end
    if love.keyboard.isDown("right") then
        angle = angle + 2 * dt
    end
end

function love.draw()
    love.graphics.translate(position.x, position.y)
    love.graphics.rotate(angle)
    love.graphics.rectangle("fill", -25, -10, 50, 20)  -- Draw a rotated rectangle
end
```

---

## **6. Advanced: Adding Velocity and Acceleration**
By adding velocity as another vector, you can smooth out movement with acceleration and deceleration.

### Example:
```lua
local velocity = vector(0, 0)
local friction = 0.9  -- Reduce velocity gradually

function love.update(dt)
    local acceleration = vector(0, 0)

    -- Forward/backward movement
    if love.keyboard.isDown("up") then
        acceleration = acceleration + vector(math.cos(angle), math.sin(angle)) * speed
    end
    if love.keyboard.isDown("down") then
        acceleration = acceleration - vector(math.cos(angle), math.sin(angle)) * speed
    end

    -- Strafing
    if love.keyboard.isDown("a") then
        acceleration = acceleration + vector(-math.sin(angle), math.cos(angle)) * speed
    end
    if love.keyboard.isDown("d") then
        acceleration = acceleration + vector(math.sin(angle), -math.cos(angle)) * speed
    end

    -- Update velocity with acceleration and apply friction
    velocity = (velocity + acceleration * dt) * friction

    -- Update position
    position = position + velocity * dt

    -- Rotation
    if love.keyboard.isDown("left") then
        angle = angle - 2 * dt
    end
    if love.keyboard.isDown("right") then
        angle = angle + 2 * dt
    end
end

function love.draw()
    love.graphics.translate(position.x, position.y)
    love.graphics.rotate(angle)
    love.graphics.rectangle("fill", -25, -10, 50, 20)
end
```

---

## **7. Debugging Tip: Visualize Vectors**
You can draw vectors for debugging using `love.graphics.line`:
```lua
function love.draw()
    -- Draw position
    love.graphics.circle("fill", position.x, position.y, 5)

    -- Draw facing direction
    local direction = position + vector(math.cos(angle), math.sin(angle)) * 50
    love.graphics.line(position.x, position.y, direction.x, direction.y)
end
```

---

## **8. General Advantages of Using Vectors**
1. **Simpler Code**: Operations like addition, scaling, and rotation are intuitive and concise.
2. **Reusability**: Position, velocity, and acceleration can all be handled as vectors.
3. **Consistency**: All calculations for movement are in one place, reducing errors.

Let me know if you'd like further extensions or specific examples, such as applying this to multiple objects or adding collision detection! 🚀