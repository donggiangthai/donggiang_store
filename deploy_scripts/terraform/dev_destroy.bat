terraform apply --destroy --auto-approve
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
rmdir /Q /S .\.terraform
del .\.terraform.lock.hcl