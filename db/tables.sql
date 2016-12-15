CREATE TABLE "contact_information" (
  id SERIAL PRIMARY KEY,
  phone VARCHAR(255),
  website VARCHAR(255),
  facebook VARCHAR(255),
  twitter VARCHAR(255),
  linkedin VARCHAR(255),
  google_plus VARCHAR(255),
  is_active BOOLEAN DEFAULT TRUE
);


CREATE TABLE "location" (
  id SERIAL PRIMARY KEY,
  location_name VARCHAR(255),
  street_address1 VARCHAR(255),
  street_address2 VARCHAR(255),
  city VARCHAR(255),
  province VARCHAR(255),
  state VARCHAR(255),
  country VARCHAR(255),
  zip VARCHAR(255),
  latitude VARCHAR(255),
  longitude VARCHAR(255),
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE "company" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  description VARCHAR(255),
  email VARCHAR(255),
  company_type VARCHAR(255),
  founded VARCHAR(255),
  employed_size VARCHAR(255),
  location_id INT references location(id),
  contact_information_id INT references contact_information(id),
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE "user_account" (
  id SERIAL PRIMARY KEY,
  acc_level INT,
  fname VARCHAR(50),
  mname VARCHAR(50),
  lname VARCHAR(50),
  email VARCHAR(50),
  birthday DATE,
  gender VARCHAR(20),
  title VARCHAR(50),
  status VARCHAR(50),
  password VARCHAR(255),
  location_id INT references location(id),
  contact_information_id INT references contact_information(id),
  company_id INT references company(id),
  is_active BOOLEAN DEFAULT TRUE
 );

CREATE TABLE "one_way_interview" (
  id SERIAL PRIMARY KEY,
  created_time DATE,
  modified_time DATE,
  applicant_id INT REFERENCES user_account(id),
  interviewer_id INT REFERENCES user_account(id),
);

CREATE TABLE "question" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  one_way_interview_id INT REFERENCES one_way_interview(id),
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE "video_upload" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  file_path VARCHAR(255),
  is_active BOOLEAN DEFAULT TRUE,
  user_account_id INT references user_account(id),
  one_way_interview_id INT REFERENCES one_way_interview(id),
);