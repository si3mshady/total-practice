USE master
GO
CREATE LOGIN ag_login WITH PASSWORD = 'P@ssw0rd'
GO
CREATE USER ag_user FOR LOGIN ag_login;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd'
GO
CREATE CERTIFICATE ag_certificate   
    AUTHORIZATION ag_user
    FROM FILE = '/usr/work/ag_certificate.cer'
    WITH PRIVATE KEY (
    FILE = '/usr/work/ag_certificate.pvk',
    DECRYPTION BY PASSWORD = 'P@ssw0rd'
)
GO
CREATE ENDPOINT [Hadr_endpoint]
AS TCP (LISTENER_IP = ALL, LISTENER_PORT = 5022)
FOR DATA_MIRRORING (ROLE = ALL, AUTHENTICATION = CERTIFICATE ag_certificate,
ENCRYPTION = REQUIRED ALGORITHM AES);
GO
ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED;
GO
ALTER EVENT SESSION  AlwaysOn_health ON SERVER WITH (STARTUP_STATE=ON);
GO
GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [ag_login]
GO