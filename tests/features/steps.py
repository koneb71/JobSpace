from lettuce import step, world, before
from nose.tools import assert_equals
from webtest import *
from app import flask_app
from app import *
import json
import base64

@before.all
def before_all():
    world.app = flask_app.test_client()

    world.headers = {'Authorization': 'Basic %s' % (
        base64.b64encode("test:test"))}

#Adding User

@step(u'Given I have the following user details:')
def given_i_have_the_following_user_details(step):
    world.info = step.hashes[0]

@step(u'When I click the register button')
def when_i_click_the_register_button(step):
    world.browser = TestApp(app)
    world.api = '/api/v1.0/user/create'
    world.response = world.app.post(world.api, data=json.dumps(world.info))

@step(u'Then I will get a \'([^\']*)\' response')
def then_i_will_get_a_group1_response(step, expected_status_code):
    assert_equals(world.response.status_code, int(expected_status_code))\

@step(u'And it should have a field "([^"]*)" containing "([^"]*)"')
def and_it_should_have_a_field_group1_containing_group2(step, group1, message):
    world.resp = json.loads(world.response.data)
    assert_equals(world.resp['message'], message)

#Retrieve

@step(u'Given a user id \'([^\']*)\'')
def given_a_user_id_group1(step, id):
    world.browser = TestApp(app)
    world.id = id

@step(u'When I retrieve user account id \'([^\']*)\'')
def when_i_retrieve_hotel_personnel_group1(step, id):
    world.resp = world.app.get('/api/v1.0/user/{}/'.format(id))

@step(u'And the following user details are returned:')
def and_the_following_user_details_are_returned(step):
    assert_equals(step.hashes, [json.loads(world.resp.data)])


#LOGIN

@step(u"login details")
def given_login_details(step):
    world.login = step.hashes[0]


@step("I click login button")
def when_i_click_login_button(step):
    world.browser = TestApp(app)
    world.response = world.app.post('/api/v1.0/user/login/', data = json.dumps(world.login))

@step("get a \'(.*)\' response")
def then_i_should_get_a_200_response(step, expected_status_code):
    assert_equals(world.response.status_code, int(expected_status_code))


@step('message "Successfully Logged In" is returned')
def message_res(step):
    world.respn = json.loads(world.response.data)
    assert_equals(world.respn['message'], "Successfully Logged In")