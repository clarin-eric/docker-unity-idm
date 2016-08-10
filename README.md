# Unity-idm docker container

this dockerfile builds a debian based container running unity-idm 1.5.0 (http://unity-idm.eu/).

## Building
```
docker build -t wilelb/unity-idm .
```

## Running
In order to run the unity-idm container we create two containers: (1) a volume container, "unity-idm_data", and (2) the container running the server itself, "unity-idm".
The volume container store configuration, log and database files.
```
docker create --name unity-idm_data wilelb/unity-idm
docker create --volumes-from unity-idm_data -p 2443:2443 --name unity-idm wilelb/unity-idm
```

After creating the containers, use the docker start command to acually start the unity-idm server:
```
docker start unity-idm
```

As soon as the container is running you can access the unity-idm administration user interface vi https://<IP>:2443/admin/admin.
Where <IP> is the ip address of the host running your docker daemon. In case of boot2docker, use "boot2docker ip" to get the ip address.

The server is configured to both log to stdout (this is what will be visible in your containers output) and to <unity-idm>/logs/unity-server.log.

Stopping the container:
```
docker stop unity-idm
```

## Usage

Attach an interactive shell:
```
docker exec -i -t unity-idm /bin/bash
```

Tail the main server output:
```
docker logs --tail=100 -f unity-idm 
```

When fiddling around it can be useful to repeatedly start the container. Instead of using the persistent container, disposable containers can be run as follows:
```
docker run -t -i --rm -p 2443:2443 wilelb/unity-idm
```
Note: these containers are run interactively and will shut down as soon as the unity-idm server is stopped (CTR+C). After shutdown the container is removed ("--rm" flag).



```
"""
stop at pl.edu.icm.unity.ldap.endpoint.LdapApacheDSInterceptor:188

+-------------------------------+--------------------------------------+
| Configuration                 |                                      |
+-------------------------------+--------------------------------------+
| hasMemberOfFilterSupport      | 0                                    |
| hasPagedResultSupport         |                                      |
| homeFolderNamingRule          |                                      |
| lastJpegPhotoLookup           | 0                                    |
| ldapAgentName                 | uid=admin,ou=system                  |
| ldapAgentPassword             | ***                                  |
| ldapAttributesForGroupSearch  |                                      |
| ldapAttributesForUserSearch   |                                      |
| ldapBackupHost                |                                      |
| ldapBackupPort                |                                      |
| ldapBase                      | ou=system                            |
| ldapBaseGroups                | ou=groups,ou=system                  |
| ldapBaseUsers                 | ou=users,ou=system                   |
| ldapCacheTTL                  | 600                                  |
| ldapConfigurationActive       | 1                                    |
| ldapDynamicGroupMemberURL     |                                      |
| ldapEmailAttribute            |                                      |
| ldapExperiencedAdmin          | 0                                    |
| ldapExpertUUIDGroupAttr       |                                      |
| ldapExpertUUIDUserAttr        |                                      |
| ldapExpertUsernameAttr        |                                      |
| ldapGroupDisplayName          | cn                                   |
| ldapGroupFilter               |                                      |
| ldapGroupFilterGroups         |                                      |
| ldapGroupFilterMode           | 0                                    |
| ldapGroupFilterObjectclass    |                                      |
| ldapGroupMemberAssocAttr      | uniqueMember                         |
| ldapHost                      | unity-idm                            |
| ldapIgnoreNamingRules         |                                      |
| ldapLoginFilter               | (&(|(objectclass=inetorgperson))(uid=%uid)) |
| ldapLoginFilterAttributes     |                                      |
| ldapLoginFilterEmail          | 0                                    |
| ldapLoginFilterMode           | 0                                    |
| ldapLoginFilterUsername       | 1                                    |
| ldapNestedGroups              | 0                                    |
| ldapOverrideMainServer        |                                      |
| ldapPagingSize                | 500                                  |
| ldapPort                      | 10000                                |
| ldapQuotaAttribute            |                                      |
| ldapQuotaDefault              |                                      |
| ldapTLS                       | 0                                    |
| ldapUserDisplayName           | displayName                          |
| ldapUserDisplayName2          |                                      |
| ldapUserFilter                | (|(objectclass=inetorgperson))              |
| ldapUserFilterGroups          |                                      |
| ldapUserFilterMode            | 0                                    |
| ldapUserFilterObjectclass     | person                               |
| ldapUuidGroupAttribute        | auto                                 |
| ldapUuidUserAttribute         | auto                                 |
| turnOffCertCheck              | 0                                    |
| useMemberOfToDetectMembership | 1                                    |
+-------------------------------+--------------------------------------+
"""
```



```
ssh -f test@127.0.0.1 -L 4000:127.0.0.1:4000 -N -p 9000
```