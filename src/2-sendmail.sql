CREATE FUNCTION sendEmail (_to text, _subject text, _body text)
  RETURNS integer
AS $$
  import smtplib
  from email.mime.text import MIMEText
  def getConfig(_key_val):
    plan = plpy.prepare("SELECT _value FROM configuracion where _key = $1", ["text"])
    rv = plpy.execute(plan,[_key_val],1)
    if (len(rv)>0):
      return rv[0]["_value"]
    else:
      raise Exception ("key "+_key_val+"not provided")
  i = 0
  _from = getConfig('email_user')
  _smtp = getConfig('smtp_server')
  _smtp_port = getConfig('smtp_port')
  _port = int(_smtp_port)
  _password = None
  try:
    _password = getConfig('email_password')
  except Exception as e:
    i=2
    plpy.log(str(e))
  msg = MIMEText(_body)
  msg['Subject'] = _subject
  msg['From'] = _from
  msg['To'] = _to
  to = [_to]
  try:
    if (_port==25):
      server=smtplib.SMTP(_smtp,_port)
      server.ehlo()
      if (_password != None):
        
        server.login(_from,_password)
      server.sendmail(_from, to, msg.as_string())
      server.close()
      i=4
    else:
      server=smtplib.SMTP_SSL(_smtp,_port)
      server.ehlo()
      server.login(_from,_password)
      server.sendmail(_from, to, msg.as_string())
      server.close()
      i=5
  except Exception as e:
    i=7
    plpy.log(str(e))
  return i
$$ LANGUAGE plpython3u;