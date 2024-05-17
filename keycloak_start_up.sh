docker run --name keycloak -d -p 8080:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=password -e KC_FEATURES=token-exchange,admin-fine-grained-auth quay.io/keycloak/keycloak:24.0.4 start-dev
