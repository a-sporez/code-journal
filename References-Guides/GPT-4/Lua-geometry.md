This function, `updateTurn`, helps the entity turn toward a `targetAngle` smoothly by adjusting the current `angle` in small increments controlled by `turnSpeed`. Here’s a detailed breakdown of the math:

### 1. Calculate the Angle Difference
```lua
local angleDiff = self.targetAngle - self.angle
```
This calculates the difference between the current facing angle (`self.angle`) and the desired facing angle (`self.targetAngle`). This difference (`angleDiff`) tells us the direction and distance the entity needs to turn to face the target angle.

### 2. Normalize `angleDiff` to the Range `[-π, π]`
```lua
angleDiff = (angleDiff + math.pi) % (2 * math.pi) - math.pi
```
This line normalizes `angleDiff` to fall within the range \([-π, π]\). Here’s why this normalization is important and how it works:

- **Why Normalize?**
  - Without normalization, `angleDiff` might be greater than `π` or less than `-π`, causing the entity to turn the long way around to reach `targetAngle`.
  - By normalizing, we ensure the entity turns in the shortest direction, clockwise or counterclockwise, to face the target.

- **How It Works:**
  1. **Add `π`**: This shifts `angleDiff` by `π` radians to handle negative values.
  2. **Modulo Operation (`% (2 * π)`)**: This keeps the result within a 2π range (0 to 2π) by effectively “wrapping” values outside this range back around.
  3. **Subtract `π`**: This final shift returns `angleDiff` to a range between `-π` and `π`.

So, if `angleDiff` is slightly above `π`, this code adjusts it down to fall within `[-π, π]`, ensuring a consistent and shortest possible rotation.

### 3. Check if `angleDiff` is Small Enough to Snap to `targetAngle`
```lua
if math.abs(angleDiff) < self.turnSpeed * dt then
    self.angle = self.targetAngle
```
This line checks if `angleDiff` is already within a small threshold (determined by `turnSpeed * dt`). Here:
- `turnSpeed * dt` gives the maximum angle change allowed in one frame. 
- If `angleDiff` is smaller than this, we can set `self.angle` directly to `targetAngle` because we’re close enough that the remaining difference can be closed in one frame.

### 4. Adjust `self.angle` Gradually
```lua
else
    self.angle = self.angle + math.sign(angleDiff) * self.turnSpeed * dt
end
```
If `angleDiff` is larger than the threshold, we move `self.angle` gradually in the direction of `targetAngle` by adding a small rotation each frame. Here’s how:

- `math.sign(angleDiff)`: Returns `1` if `angleDiff` is positive (target angle is clockwise) and `-1` if it’s negative (target angle is counterclockwise).
- `self.turnSpeed * dt`: This is the increment of rotation allowed per frame.

By multiplying these, `self.angle` is updated in the shortest direction, advancing the entity’s angle incrementally toward `targetAngle`.

### 2. Refined `moveToTarget` with Turn Speed and Acceleration

Here’s how you can adjust the `moveToTarget` function to use acceleration/deceleration and turn speed.

```lua
moveToTarget = function(self, dt)
    if self.target then
        local dx, dy = self.target.x - self.x, self.target.y - self.y
        local targetDistance = math.sqrt(dx * dx + dy * dy)

        -- Update target angle
        self.targetAngle = math.atan2(dy, dx)

        -- Calculate angle difference and normalize it
        local angleDiff = (self.targetAngle - self.angle + math.pi) % (2 * math.pi) - math.pi
        if math.abs(angleDiff) < self.turnSpeed * dt then
            self.angle = self.targetAngle
        else
            self.angle = self.angle + math.sign(angleDiff) * self.turnSpeed * dt
        end

        -- Speed adjustment: accelerate, move, or decelerate
        if targetDistance > 1 then
            self.velocity = math.min(self.velocity + self.acceleration * dt, self.maxSpeed)
        else
            self.velocity = math.max(self.velocity - self.deceleration * dt, 0)
        end

        -- Move entity in the direction of `self.angle`
        self.x = self.x + math.cos(self.angle) * self.velocity * dt
        self.y = self.y + math.sin(self.angle) * self.velocity * dt

        -- Stop at target if close enough
        if targetDistance < 1 then
            self.target = nil
            self.velocity = 0
        end
    end
end
```

### Explanation

- **Target Angle Calculation**: `self.targetAngle` is calculated using `math.atan2(dy, dx)`, which gives the angle between the entity’s position and the target.
- **Angle Difference and Turn Speed**: `angleDiff` is the difference between the current angle and the target angle, normalized to the shortest path. The entity adjusts its `angle` based on `turnSpeed`.
- **Acceleration/Deceleration**: If the entity is moving toward the target, it accelerates up to `maxSpeed`. If it’s close to the target, it decelerates to a stop.
- **Movement Using Velocity and Angle**: Finally, the entity moves by updating `x` and `y` according to the current `angle` and `velocity`.

Let’s go through each part of the `moveToTarget` function, step-by-step, to understand the math behind it.

### 1. Calculating Distance and Direction to Target
```lua
local dx, dy = self.target.x - self.x, self.target.y - self.y
local targetDistance = math.sqrt(dx * dx + dy * dy)
```
- **dx** and **dy** represent the differences in the x and y coordinates between the entity’s current position (`self.x`, `self.y`) and the target’s position (`self.target.x`, `self.target.y`).
- **targetDistance** is the straight-line distance between the entity and the target. Calculated with the Pythagorean theorem: \(\text{distance} = \sqrt{dx^2 + dy^2}\).

### 2. Updating the Target Angle
```lua
self.targetAngle = math.atan2(dy, dx)
```
- **self.targetAngle** is set using `math.atan2(dy, dx)`, which computes the angle in radians from the entity to the target.
- `math.atan2(dy, dx)` considers the signs of `dx` and `dy` to find the correct quadrant, giving an angle between `-π` and `π`.

### 3. Calculating Angle Difference and Normalizing It
```lua
local angleDiff = (self.targetAngle - self.angle + math.pi) % (2 * math.pi) - math.pi
```
- **angleDiff** is the difference between the **target angle** (where the entity wants to face) and the **current angle** (`self.angle`), which represents where the entity is currently facing.
- To avoid abrupt rotation, this angle difference is **normalized** to fall between `-π` and `π`. This avoids excessive turning by choosing the shortest rotational path.

Normalization step-by-step:
  - `(self.targetAngle - self.angle + math.pi)` adjusts the angle difference by adding `π` to shift it for easier modulo calculation.
  - `% (2 * math.pi)` reduces it within the range `[0, 2π)`.
  - `- math.pi` shifts the value back to the `[-π, π)` range, giving a balanced angle difference.

### 4. Rotating Towards the Target
```lua
if math.abs(angleDiff) < self.turnSpeed * dt then
    self.angle = self.targetAngle
else
    self.angle = self.angle + math.sign(angleDiff) * self.turnSpeed * dt
end
```
- This step ensures that the entity turns smoothly toward the target:
  - **TurnSpeed** limits the angle change per frame, giving controlled turning.
  - **math.sign(angleDiff)** determines the rotation direction (clockwise or counterclockwise).
  - If `angleDiff` is small enough, the entity snaps to `self.targetAngle`, so it doesn’t overshoot. Otherwise, it gradually turns by `self.turnSpeed * dt`.

### 5. Speed Adjustment: Accelerate, Move, or Decelerate
```lua
if targetDistance > 1 then
    self.velocity = math.min(self.velocity + self.acceleration * dt, self.maxSpeed)
else
    self.velocity = math.max(self.velocity - self.deceleration * dt, 0)
end
```
- The entity accelerates toward `maxSpeed` while far from the target and decelerates as it nears the target:
  - **Acceleration**: When far (e.g., `targetDistance > 1`), the entity’s `velocity` increases by `acceleration * dt` up to `maxSpeed`.
  - **Deceleration**: When close (e.g., `targetDistance <= 1`), `velocity` decreases by `deceleration * dt` down to 0, allowing it to stop at the target.

### 6. Moving the Entity
```lua
self.x = self.x + math.cos(self.angle) * self.velocity * dt
self.y = self.y + math.sin(self.angle) * self.velocity * dt
```
- The entity’s movement uses its current **angle** and **velocity**:
  - `math.cos(self.angle)` calculates the x-direction component based on the angle, while `math.sin(self.angle)` does the same for the y-direction.
  - **`self.velocity * dt`** scales these components to move the entity appropriately in both x and y directions.

### 7. Stopping at the Target
```lua
if targetDistance < 1 then
    self.target = nil
    self.velocity = 0
end
```
- If the entity is close enough to the target (`targetDistance < 1`), it stops by setting `self.target` to `nil` and `self.velocity` to 0, preventing further movement and turning.

This breakdown should help clarify the math used to control the entity’s movement, turning, and stopping behavior. Let me know if you'd like further details on any of these steps!