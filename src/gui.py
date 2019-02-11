from kivy.app import App
from kivy.uix.widget import Widget
from kivy.properties import NumericProperty, ReferenceListProperty,\
    ObjectProperty, ListProperty
from kivy.vector import Vector
from kivy.clock import Clock
from kivy.core.window import Window

import numpy as np

# Create a Julia session with the appropriate contraption loaded
def open_jl(contraption):

    # Return way to access that session
    return True

# Update variables in Julia session to reflect current state
def update_jl(jl_session, contraption = None, inputs = None):

    return True

# Fetch next system state
def physics_jl(jl_session, dt):

    # Return a matrix of coordinates
    return True

class PlayArea(Widget):
    pass

class Mass(Widget):
    pass

class Spring(Widget):
    mass_1 = ObjectProperty(None)
    mass_2 = ObjectProperty(None)

    start = ListProperty((0,0))
    end = ListProperty((0,0))

class Contraption(Widget):

    def connect(self):
        # Fully connect all points
        mass_list = list(filter(lambda x: type(x) is Mass, self.children))
        n = len(mass_list)

        for i in range(0, n-1):
            for j in range(i+1, n):
                spring_ij = Spring()
                spring_ij.mass_1 = mass_list[i]
                spring_ij.mass_2 = mass_list[j]

                self.add_widget(spring_ij)

        # TODO: record spring strength and presence
        self.springs = "NYI"
        
        return True

    def update(self, dt):

        # Fetch updated positions given by physics engine
        positions = physics_jl(self.jl_session, dt)

        # Update mass position
        for component in filter(lambda x: type(x) is Mass, self.children):
            component.pos = positions + "NYI"

        # Update spring position
        for component in filter(lambda x: type(x) is Spring, self.children):
            component.start = component.mass_1.center
            component.end = component.mass_2.center

        return True

class SpringGame(Widget):
    contraption = ObjectProperty(None)
    play_area = ObjectProperty(None)

    def __init__(self, **kwargs):
        super(SpringGame, self).__init__(**kwargs)
        self._keyboard = Window.request_keyboard(self._keyboard_closed, self)
        self._keyboard.bind(on_key_down=self._on_keyboard_down)

    def _keyboard_closed(self):
        self._keyboard.unbind(on_key_down=self._on_keyboard_down)
        self._keyboard = None

    def _on_keyboard_down(self, keyboard, keycode, text, modifiers):        

        # FIXME: Allow for multiple inputs to be pressed at once
        if keycode[1] == 'w':
            update_jl(self.jl_session, inputs = ["up"])
        elif keycode[1] == 's':
            update_jl(self.jl_session, inputs = ["down"])
        elif keycode[1] == 'd':
            update_jl(self.jl_session, inputs = ["right"])
        elif keycode[1] == 'a':
            update_jl(self.jl_session, inputs = ["left"])
        return True

    def update(self, dt):
        self.contraption.update(dt)
        return True

    # FIXME: right clicking creates phantom point
    # FIXME: does not spawn at touched location on Ubuntu. Might be coordinate issue?
    def on_touch_down(self, touch):
        new_mass = Mass(center_x = touch.x,
                        center_y = touch.y)
        self.contraption.add_widget(new_mass)

        self.contraption.connect()

        update_jl(self.jl_session, contraption = self.contraption)

        return True

class SpringApp(App):
    def build(self):
        game = SpringGame()

        # Open Julia physics engine
        open_jl(game.contraption) 

        # Clock passes dt as argument to game.update
        dt = 1.0 / 60.0
        Clock.schedule_interval(game.update, dt)
        return game


if __name__ == '__main__':
        SpringApp().run()
