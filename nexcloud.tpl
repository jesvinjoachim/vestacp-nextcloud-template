<VirtualHost %ip%:%web_ssl_port%>

    ServerName %domain_idn%
    %alias_string%
    ServerAdmin %email%
    DocumentRoot %sdocroot%
    ScriptAlias /cgi-bin/ %home%/%user%/web/%domain%/cgi-bin/
    Alias /vstats/ %home%/%user%/web/%domain%/stats/
    Alias /error/ %home%/%user%/web/%domain%/document_errors/
    #SuexecUserGroup %user% %group%
    CustomLog /var/log/%web_system%/domains/%domain%.bytes bytes
    CustomLog /var/log/%web_system%/domains/%domain%.log combined
    ErrorLog /var/log/%web_system%/domains/%domain%.error.log

    # run "a2enmod headers" if this isn't working
    <IfModule mod_headers.c>
      Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains; preload"
    </IfModule>

    <Directory %sdocroot%>
        AllowOverride All
        SSLRequireSSL
        Options +Includes -Indexes +ExecCGI
        php_admin_value open_basedir %docroot%:%home%/%user%/web/%domain%/private:%home%/%user%/tmp:/dev/urandom
        php_admin_value upload_tmp_dir %home%/%user%/tmp
        php_admin_value session.save_path %home%/%user%/tmp
    </Directory>
    <Directory %home%/%user%/web/%domain%/stats>
        AllowOverride All
    </Directory>
    SSLEngine on
    SSLVerifyClient none
    SSLCertificateFile %ssl_crt%
    SSLCertificateKeyFile %ssl_key%
    %ssl_ca_str%SSLCertificateChainFile %ssl_ca%

    <IfModule mod_ruid2.c>
        RMode config
        RUidGid %user% %group%
        RGroups www-data
    </IfModule>
    <IfModule itk.c>
        AssignUserID %user% %group%
    </IfModule>

    IncludeOptional %home%/%user%/conf/web/s%web_system%.%domain%.conf*

</VirtualHost>
