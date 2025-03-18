# Auth Helpfer

This repository contains an Azure Function that provides authentication tokens for applications. The function is designed to issue SAS (Shared Access Signature) tokens for accessing Azure Cognitive Services.

## Overview

The Azure Function is implemented using Python and leverages the Azure Functions framework. It exposes an HTTP endpoint that can be called anonymously to retrieve a SAS token. The token is generated based on environment variables that must be configured in the Azure Function App.

## Function Details

### Endpoint

- **Route**: `cs/token`

## Environment Variables

The following environment variables must be set for the function to work:

- `AZURE_REGION`: The Azure region where the Cognitive Services resource is located.
- `AZURE_SUBSCRIPTION_KEY`: The subscription key for the Azure Cognitive Services resource.

## Deployment

1. Create an Azure Function App in your Azure subscription.
2. Configure the required environment variables in the Function App settings.
3. Deploy the function code to the Azure Function App.

## Usage

Send an HTTP POST request to the endpoint `/cs/token` to retrieve a SAS token. Ensure that the environment variables are correctly configured before making the request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.# authhelper
