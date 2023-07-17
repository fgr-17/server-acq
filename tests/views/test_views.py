import unittest
from flask_testing import TestCase
from app import app  # Replace with the actual import of your flask app
from flask import session, url_for

class MyTest(TestCase):

    def create_app(self):
        app.config['TESTING'] = True
        app.config['WTF_CSRF_ENABLED'] = False
        return app

    def test_index(self):
        with app.test_client() as c:
            response = c.get('/')
            self.assertEqual(response.status_code, 302) # Expect redirect to /login as no user in session

    def test_login_and_logout(self):
        with app.test_client() as c:
            response = c.post('/login', data={'username': 'a', 'password': 'a'}, follow_redirects=True)
            self.assertEqual(response.status_code, 200)
            self.assertIn('username', session) # After login, 'username' should be in session
            self.assertIn(b'Logged in as', response.data)

            response = c.get('/logout', follow_redirects=True)
            self.assertEqual(response.status_code, 200)
            self.assertNotIn('username', session) # After logout, 'username' should not be in session

    def test_about(self):
        with app.test_client() as c:
            response = c.get('/about')
            self.assertEqual(response.status_code, 302) # Expect redirect to /login as no user in session

            # Login before trying to access /about
            c.post('/login', data={'username': 'a', 'password': 'a'}, follow_redirects=True)
            response = c.get('/about')
            self.assertEqual(response.status_code, 200)  # Now the response should be OK

# More tests for other routes

if __name__ == '__main__':
    unittest.main()

