from kivy.app import App
from kivy.uix.widget import Widget
from kivy.properties import NumericProperty, ReferenceListProperty,\
    ObjectProperty
from kivy.vector import Vector
from kivy.clock import Clock
from kivy.core.window import Window


class PlayArea(Widget):
    pass

class SpringBall(Widget):
    velocity_x = NumericProperty(0)
    velocity_y = NumericProperty(0)
    velocity = ReferenceListProperty(velocity_x, velocity_y)

    def move(self):
        self.pos = Vector(*self.velocity) + self.pos

class SpringGame(Widget):
    ball = ObjectProperty(None)

    def __init__(self, **kwargs):
        super(SpringGame, self).__init__(**kwargs)
        self._keyboard = Window.request_keyboard(self._keyboard_closed, self)
        self._keyboard.bind(on_key_down=self._on_keyboard_down)

    def _keyboard_closed(self):
        self._keyboard.unbind(on_key_down=self._on_keyboard_down)
        self._keyboard = None

    def _on_keyboard_down(self, keyboard, keycode, text, modifiers):
        if keycode[1] == 'w':
            self.ball.velocity_y += 1
        elif keycode[1] == 's':
            self.ball.velocity_y -= 1
        elif keycode[1] == 'd':
            self.ball.velocity_x += 1
        elif keycode[1] == 'a':
            self.ball.velocity_x -= 1
        return True

    def serve_ball(self, vel=(4, 1)):
        self.ball.center = self.center
        self.ball.velocity = vel

    def update(self, dt):
        self.ball.move()

        # FIXME: bounce off play area instead
        # bounce ball off sides
        if (self.ball.x < self.x) or (self.ball.right > self.right):
            self.ball.velocity_x *= -1

        # bounce ball off bottom or top
        if (self.ball.y < self.y) or (self.ball.top > self.top):
            self.ball.velocity_y *= -1



    def on_touch_down(self, touch):
        new_ball = SpringBall(center_x = touch.x,
                            center_y = touch.y)
        self.add_widget(new_ball)
        return True

class SpringApp(App):
    def build(self):
        game = SpringGame()
        game.serve_ball()
        Clock.schedule_interval(game.update, 1.0 / 60.0)
        return game


if __name__ == '__main__':
        SpringApp().run()