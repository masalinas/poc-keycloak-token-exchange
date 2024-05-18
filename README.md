# Description
PoC Keycloak Token Exchange and Impersonation

## Introduccion

In Keycloak, token exchange is the process of using a set of credentials or token to obtain an entirely different token. Exist 4 token exchange implementations:

1. A client may want to invoke on a less trusted application so it may want to downgrade the current token it has.
2. A client may want to exchange a Keycloak token for a token stored for a linked social provider account. 
3. You may want to trust external tokens minted by other Keycloak realms or foreign IDPs.
4. A client may have a need to impersonate a user

Here’s a short summary of the current capabilities of Keycloak around token exchange:

1. **Internal token to internal token exchange**: A client can exchange an existing Keycloak token created for a specific client for a new token targeted to a different client
2. **Internal token to external token exchange**: A client can exchange an existing Keycloak token for an external token, i.e. a linked Facebook account
3. **External token to internal token exchange**: A client can exchange an external token for a Keycloak token
4. **Impersonation**: A client can impersonate a user

In all of them the uri to request this exchange is always de same:

```shell
/realms/{realm}/protocol/openid-connect/token
```

## Install infrastructure:

Before start we need a Keycloak instance correctly configured. By default the **Token Exchange Permissions** and **User Detail Management Permissions** feature are not actived in Keycloak so we must to deploy Keycloak with these features included. We will used these configuration:

- **Port**: 8088
- **Keycload admin credentials**: admin/password
- **Properties to be activated**: token-exchange, admin-fine-grained-authz. Note: **impersonation feature is activated by default but you need activate admin-fine-grained-authz to be configured.**
- **Image Tag**: quay.io/keycloak/keycloak:24.0.4

Execute this docker command:

```shell
docker run -d --name keycloak -p 8088:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=password -e KC_FEATURES=token-exchange,admin-fine-grained-authz quay.io/keycloak/keycloak:24.0.4 start-dev
```

## Creare initial resources

**STEP01**: Create a new realm where configure the keycloak resources like: clients, users, groups, permissions and policies.

![Realm Name](./images/realm-name.png "Realm Name")

**STEP02**: Create two clients to configure the token-exchange between them:

First create the **Original Client** to exchange a token with other one from **Internal Client** with this data:

- **Client ID**: originalclient
- **Name**: Original Client
- **Client authentication**: true

Original Client Name Step:
![Original Client Name"](./images/original-client-name.png "Original Client Name")

Original Client Authentication Flag Step:
![Original Client Authentication"](./images/original-client-authentication.png "Original Client Authentication")

Later we can get the client secret from the **Credentials Tab** inside the client just created:

![Client Secret"](./images/client-secret.png "Client Secret")

Second create the **Internal Client** where we defined a permission to permit exchange tokens with this data:

- **Client ID**: internalclient
- **Name**: Internal Client
- **Client authentication**: true

Internal Client Name Step:
![Internal Client Name"](./images/internal-client-name.png "Internal Client Name")

Internal Client Authentication Flag Step:
![Internal Client Authentication"](./images/internal-client-authentication.png "Internal Client Authentication")

Also we can recover the client secret used in the next requests.

**STEP03**: Create a admin user with a admin role to be tested

Create the **Admin Role** from Realm roles option menu like this:

![Admin Role"](./images/admin-role.png "Admin Role")

Create the **Admin User** with credentials from Users option menu like this:

![Admin User"](./images/admin-user.png "Admin User")

Set credentiasl password from credentials. Set not validate the credentials, like this:

![Admin Credentials"](./images/admin-credentials.png "Admin Credentials")

## Exchange Token Steps

We are going to explain all steps to configure and test a token exchange between two clients in Keycloak

**STEP01**: Create a permission called **token-exchange** from client **Internal Client** in **Permissions** Tab like this:

We must activate permissions enabled (this tab exist because we start Keycloak with the token-exchange option):

![Permission Token Exchange"](./images/permission-token-exchange.png "Permission Token Exchange")

**STEP02**: Create a client policy attached to the **Original Client**

![Client Policy"](./images/client-policy.png "Client Policy")

**STEP03**: Bind the Client Policy to the **Internal Client**

![Bind Client Policy"](./images/bind-client-policy.png "Bind Client Policy")

## Make a test for exchange token

**STEP01**: Issue a token from **Original Client** using the admin credentials:

![Token Original Client"](./images/token-original-client.png "Token Original Client")

**STEP02**: Requets an exchange token obtained before with a new one from **Internal Client**

![Exchange Original Client Token"](./images/exchange-token-internal-client.png "Exchange Original Client Token")

**STEP03**: We can check the session impersonate

![Keycloack Session Impersonate"](./images/keycloak-session.png "Keycloack Session Impersonate")

## Impersonation Steps

We are going to explian all steps to configure and test a user impersonation between two users in Keycloak
Now we have all resources already created: users, groups and clients. **We only must bind a new polity to the impersonation permission.**

Go to **Users** menu item, **permission tabs** (activate from admin-fine-grained-authz feature) and bind a **client policy** like this:

![Impersonate Permission"](./images/impersonate-permission-for-client.png "Impersonate Permission for client policy")

If we want impersonate using a **user policty**:

![Impersonate Permission"](./images/impersonate-permission-for-user.png "Impersonate Permission for user policy")

## Make a test for Impersonation

**STEP01**: Issue a token from **Original Client** using the admin credentials as previous

![Token Original Client"](./images/token-original-client.png "Token Original Client")

**STEP02**: impersonate our token from admin user to user account

![Impersonate Token"](./images/impersonate-token.png "Impersonate Token")

**STEP03**: We can check the session impersonate

![Keycloack Impersonation Session"](./images/impersonation-sessions.png "Keycloack Impersonation Session")

**STEP04**: We can check the new token, how the role is for **user** inside the **Original Client**

!["Token Decoded"](./images/token-decoded.png "Token Decoded")

## Some Links

- [Token Exchange RFC](https://datatracker.ietf.org/doc/html/rfc8693)
- [Keycloak Getting Started](https://www.keycloak.org/getting-started/getting-started-docker)
- [Keycloak Exchange Token Documentation](https://www.keycloak.org/docs/latest/securing_apps/#_token-exchange)

