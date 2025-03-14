import azure.functions as func
import logging
import os
import requests

app = func.FunctionApp()


@app.route(route="GetAuthToken", auth_level=func.AuthLevel.ANONYMOUS)
def GetAuthToken(req: func.HttpRequest) -> func.HttpResponse:
    def get_sas_token():
        region = os.getenv("AZURE_REGION")
        subscription_key = os.getenv("AZURE_SUBSCRIPTION_KEY")

        if not region or not subscription_key:
            raise ValueError(
                "AZURE_REGION and AZURE_SUBSCRIPTION_KEY environment variables must be set"
            )

        url = f"https://{region}.api.cognitive.microsoft.com/sts/v1.0/issueToken"
        headers = {
            "Content-type": "application/x-www-form-urlencoded",
            "Content-length": "0",
            "Ocp-Apim-Subscription-Key": subscription_key,
        }

        response = requests.post(url, headers=headers)
        response.raise_for_status()

        logging.info(f"Response status code: {response.status_code}")

        return response.text

    try:
        sas_token = get_sas_token()
        logging.info("SAS token retrieved successfully.")
        return sas_token
    except Exception as e:
        logging.error(f"Error retrieving SAS token: {e}")
        return func.HttpResponse("Error retrieving SAS token.", status_code=500)
