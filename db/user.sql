--user

CREATE OR REPLACE FUNCTION newuser(par_email    VARCHAR, par_fname VARCHAR, par_mname VARCHAR, par_lname VARCHAR,
                                   par_password VARCHAR, par_birthday DATE, par_gender VARCHAR, par_acc_level INT, par_title VARCHAR, par_status VARCHAR)
  RETURNS TEXT AS
$$
DECLARE
  loc_email VARCHAR;
  loc_res   TEXT;
BEGIN
  SELECT INTO loc_email par_email
  FROM user_account
  WHERE email = par_email;
  IF loc_email ISNULL
  THEN

    IF par_email = '' OR par_fname = '' OR par_mname = '' OR par_lname = '' OR par_password = ''
       OR par_gender = ''
    THEN
      loc_res = 'Error';

    ELSE
      INSERT INTO user_account (email, fname, mname, lname, birthday, gender, password, acc_level, title, status, is_active)
      VALUES (par_email, par_fname, par_mname, par_lname,
              par_birthday, par_gender, par_password, par_acc_level, par_title, par_status, TRUE);
      loc_res = 'OK';
    END IF;

  ELSE
    loc_res = 'ALREADY EXISTS!';

  END IF;
  RETURN loc_res;

END;
$$
LANGUAGE 'plpgsql';

create or replace function get_user(In par_id INT ,OUT VARCHAR, OUT VARCHAR, OUT VARCHAR, OUT VARCHAR, OUT DATE, OUT VARCHAR, OUT INT, OUT VARCHAR, OUT VARCHAR, OUT BOOLEAN) RETURNS SETOF RECORD AS
$$

  SELECT email, fname, mname, lname, birthday, gender, acc_level, title, status, is_active FROM user_account WHERE id = par_id;
$$
  LANGUAGE 'sql';

create or replace function loginauth(in par_email VARCHAR, in par_password VARCHAR) returns text as
$$
  DECLARE
    loc_email text;
    loc_password text;
    loc_res text;
  BEGIN
    select into loc_email email from user_account where email = par_email;
    select into loc_password password from user_account where password = par_password;

    if loc_email isnull or loc_password isnull or loc_email = '' or loc_password = '' then
      loc_res = 'Invalid Email or Password';
    else
      loc_res = 'Successfully Logged In';
    end if;
    return loc_res;

  END;
$$
  LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION newquestion(par_name VARCHAR, par_id INT )
  RETURNS TEXT AS
$$
DECLARE
  loc_res   TEXT;
BEGIN
    IF par_name = ''
    then
      loc_res = 'Error';

    ELSE
      INSERT INTO question (name, one_way_interview_id )
      VALUES (par_name, par_id);
      loc_res = 'OK';
    END IF;

  RETURN loc_res;

END;
$$
LANGUAGE 'plpgsql';
