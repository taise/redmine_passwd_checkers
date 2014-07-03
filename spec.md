
context 'create new user' 
  login('admin')
  create('new_user')
  current_page '/users/id/edit'

  context 'new user first login'
    login('new_user')
    current_page '/my/password'

  context 'new user second login'
    login('new_user')
    current_page '/my/page'

context 'existing user login'
  context 'first login'
    login('alice')
    current_page '/my/password'

  context 'second login'
    login('alice')
    current_page '/my/page'


context 'check password expiration'
  context 'within 3 month from the last changed'
    change_password(3.month.ago + 1.day)
    login('bob')
    current_page '/my/page'

  context 'over 3 month from the last changed'
    change_password(3.month.ago)
    login('bob')
    current_page '/my/password'

    change_password(today)
    login('bob')
    current_page '/my/page'


describe 'last_passwd'
  context 'first login'
    user.last_passwd.should be_nil
    login('eve')
    user.last_passwd.should_not be_nil

  context 'second login'
    user.last_passwd.should_not be_nil
  
  context 'change password'
    user.last_passwd.changed_at.updated

