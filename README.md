
## Ruby on Rails template ready for deploying in GCP Cloud Run with GitHub Actions Pipeline
### This proyect is about GCP deployment with Github Actions, WIF Authentication, Docker... Not about ror code. The code is mostly based in Templatus, for further information refer to that repository.

This is some basic implementation of the new github actions cloudrun deployment.
It uses WIF for Authentication as Google recomends, so no keys are needed. 

Feel free to fork and modify this repository to satisfy your needs.

*Currently working in the documentation*

# Google cloud Shell
* Coming soon *

# Google Cloud Console

## 1. Authentication.

First of all, we need to create a service account. 

IAM -> Service Accounts -> Create service account.

<img width="1440" alt="Captura de Pantalla 2022-07-09 a las 16 37 38" src="https://user-images.githubusercontent.com/24901613/178110459-d039770a-c22b-4eed-bdcd-cd93eeb0095b.png">


## 2. Grant permissions

IAM Main Page -> Edit the service account

As the account is created, it has no permissions, so we need to grant.
1. Artifact Registry Writer
2. Cloud Run Admin
3. Cloud Run Service Agent
4. Secret Manager Accesor

<img width="852" alt="Captura de Pantalla 2022-07-09 a las 16 40 45" src="https://user-images.githubusercontent.com/24901613/178110564-6d61f193-614d-4eb2-8fc5-70b81c6770cc.png">

## 3. Create WIF Identity pool
<img width="1439" alt="Captura de Pantalla 2022-07-09 a las 16 42 35" src="https://user-images.githubusercontent.com/24901613/178110621-a611ef21-6f4a-4481-a12b-04866e05c802.png">

1.Provider -> OIDC
2.Provider name -> Github-Actions
3.Issuer url -> https://token.actions.githubusercontent.com
  
  --
  
  In the next step we need to provide the attributes, this is the way to "authorize" api calls.
  
  <img width="1436" alt="Captura de Pantalla 2022-07-09 a las 16 45 49" src="https://user-images.githubusercontent.com/24901613/178110703-cf5a278f-737b-4609-a581-e85dff915290.png">
  
  I'am making requests with these parameters, however you can use whatever you want. Keep in mind that you will need to update some things in the coming steps in order to make it work correctly.
  
## 4. Add the service account to the WIF identity pool

  <img width="1440" alt="Captura de Pantalla 2022-07-09 a las 16 47 46" src="https://user-images.githubusercontent.com/24901613/178110806-8d285cb6-5a26-453e-8a20-f860a01cf35a.png">

  You should select the service account created previously.
  
  For the identities that can access the service account select: only matching the filter. 
  As I said previously this is the what that calls are authorized, for further information you can refer to github docs.

<img width="588" alt="Captura de Pantalla 2022-07-09 a las 16 50 59" src="https://user-images.githubusercontent.com/24901613/178110881-4d67fffd-511f-4974-9fa6-25c5a3fb4437.png">

  *Replace username/repository* with your data.
  
## Secrets

As rails applications different secrets are used, DB_HOST, SECRET_KEY_BASE... 

### CI SECRETS

Github Actions need to authenticate in GCP in order to access the API. For that, I am using github enviroments, in order not to mix secrets, etc... in my CI configuration I use the `deployment` environment.

First of all we need to create that environment, in Settings -> Environments. Once its created we need to add our OICD identification parameters, WIF_PROVIDER and WIF_SERVICE_ACCOUNT

* WIF_PROVIDER: Go to the GCP Cloud Console, Workload identity Federation, select your pool, "edit" and there you shoud see it.
<img width="1170" alt="Captura de Pantalla 2022-07-10 a las 21 24 01" src="https://user-images.githubusercontent.com/24901613/178159191-deb2eeef-5b3c-4980-b9bc-54935772ccf2.png">
<img width="1193" alt="Captura de Pantalla 2022-07-10 a las 21 24 29" src="https://user-images.githubusercontent.com/24901613/178159192-c8661c66-2ab6-43ec-a530-a4d9b7d4e04f.png">
* WIF_SERVICE_ACCOUNT: The service account we just created.

## SERVICE SECRETS

In other to make the rails app work, we need some secrets, as the DB_HOST or the SECRET_KEY_BASE. The way that I structure secrets, as you can see in the ci file.

       
          secrets: |
            DB_HOST=${{ secrets.SERVICE_NAME }}-dbhost:latest
            DB_USERNAME=${{ secrets.SERVICE_NAME }}-dbusername:latest
            DB_PASSWORD=${{ secrets.SERVICE_NAME }}-dbpassword:latest
            SECRET_KEY_BASE=${{ secrets.SERVICE_NAME }}-secret-key:latest 

You should AT LEAST create those secrets in GCP with your data.

## DEPLOYMENT

I want to deploy my image updated once I create a new release, however you can change this in the release.yml file, where is all the config for the ci.
