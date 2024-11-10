local love = require "love"
-- Factory pattern metatable to generate default buttons
-- Button constructor function
function Button( text, func, func_param, width, height )
    -- Create and return a new button object with default properties
    return {
        width = width or 100,                                                           -- Default width if none provided
        height = height or 100,                                                         -- Default height if none provided
        func = func or function() print( "This button has no functions attached" ) end, -- Default function if none provided
        func_param = func_param,                                                        -- Parameter to pass to the button's function, if any
        text = text or "No Text",                                                       -- Default button text if none provided
        button_x = 0,                                                                   -- Initial x position of the button
        button_y = 0,                                                                   -- Initial y position of the button
        text_x = 0,                                                                     -- Initial x position of the text (relative to the button)
        text_y = 0,                                                                     -- Initial y position of the text (relative to the button)

        -- Method to check if the button is pressed (based on mouse position and radius)
        checkPressed = function( self, mouse_x, mouse_y, cursor_radius )
            -- Check if mouse is within the button bounds
            if ( mouse_x + cursor_radius >= self.button_x ) and ( mouse_x - cursor_radius <= self.button_x + self.width ) then
                if ( mouse_y + cursor_radius >= self.button_y ) and ( mouse_y - cursor_radius <= self.button_y + self.height ) then
                    -- If there's a parameter, pass it to the function, otherwise just call the function
                    if self.func_param then
                        self.func( self.func_param )
                    else
                        self.func()
                    end
                end    
            end
        end,

        -- Method to draw the button and text
        draw = function( self, button_x, button_y, text_x, text_y )
            -- Set button position based on arguments or default to current position
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y

            -- Set text position relative to the button
            if text_x then
                self.text_x = text_x + self.button_x
            else
                self.text_x = self.button_x
            end

            if text_y then
                self.text_y = text_y + self.button_y
            else
                self.text_y = self.button_y
            end

            -- Draw the button as a rectangle (this will be replaced with an image)
            love.graphics.setColor( 0.6, 0.6, 0.6 )  -- Gray color for the button
            love.graphics.rectangle( "fill", self.button_x, self.button_y, self.width, self.height )

            -- Draw the button text
            love.graphics.setColor( 0, 0, 0 )  -- Black color for text
            love.graphics.print( self.text, self.text_x, self.text_y )

            -- Reset color back to white
            love.graphics.setColor( 1, 1, 1 )
        end
    }
end

return Button  -- Return the Button constructor function