from kivy.app import App
from kivy.uix.widget import Widget
from kivy.properties import NumericProperty, ReferenceListProperty,\
    ObjectProperty, ListProperty
from kivy.vector import Vector
from kivy.clock import Clock
from kivy.core.window import Window

class PlayArea(Widget):
    pass

class Mass(Widget):
    velocity_x = NumericProperty(0)
    velocity_y = NumericProperty(0)
    velocity = ReferenceListProperty(velocity_x, velocity_y)

    def move(self, dt):
        #self.velocity_y -= dt*1 # gravity
        self.pos = dt*Vector(*self.velocity) + self.pos # cannot use +=

class Spring(Widget):
    mass_1 = ObjectProperty(None)
    mass_2 = ObjectProperty(None)

    start = ListProperty((0,0))
    end = ListProperty((0,0))

class Contraption(Widget):
    def instantiate(self):
        mass_list = list(filter(lambda x: type(x) is Mass, self.children))
        n = len(mass_list)

        for i in range(0, n-1):
            for j in range(i+1, n):
                spring_ij = Spring()
                spring_ij.mass_1 = mass_list[i]
                spring_ij.mass_2 = mass_list[j]

                self.add_widget(spring_ij)

        return True

    def update(self, dt):
        for component in filter(lambda x: type(x) is Mass, self.children):
            # Update mass position
            component.move(dt)
                
            # Bounce mass off sides
            if (component.x < self.parent.x) or (component.right > self.parent.right):
                component.velocity_x *= -1

            # Bounce mass off bottom or top
            if (component.y < self.parent.y) or (component.top > self.parent.top):
                component.velocity_y *= -1

        for component in filter(lambda x: type(x) is Spring, self.children):
            # Update spring position
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
        keyboard_strength = 50.
        
        if keycode[1] == 'w':
            for component in self.contraption.children:
                if type(component) is Mass:
                    component.velocity_y += keyboard_strength
        elif keycode[1] == 's':
            for component in self.contraption.children:
                if type(component) is Mass:
                    component.velocity_y -= keyboard_strength
        elif keycode[1] == 'd':
            for component in self.contraption.children:
                if type(component) is Mass:
                    component.velocity_x += keyboard_strength
        elif keycode[1] == 'a':
            for component in self.contraption.children:
                if type(component) is Mass:
                    component.velocity_x -= keyboard_strength
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

        self.contraption.instantiate()

        return True

class SpringApp(App):
    def build(self):
        game = SpringGame()
        game.contraption.instantiate()
        
        # Clock passes dt as argument to game.update
        dt = 1.0 / 60.0
        Clock.schedule_interval(game.update, dt)
        return game


if __name__ == '__main__':
        SpringApp().run()
