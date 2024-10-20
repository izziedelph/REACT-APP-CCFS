INTERMEDIATE PROJECT 1 - REACT APP BEANSTALK DEPLOYMENT PROJECT 3

This first of an intermediate project which is no.3 in order following on from CCFS and CCFS-2 will deploy a react app on AWS Elastic Beanstalk. 
 My main focus of this project is the actual application itself allowing AWS Elastic Beanstalk handle server provision (EC2), load-balancing, scaling etc   
 
Step 1: Using any preconfigured react boiler plate template to get a front end ready for deployment (npx create react app /directory, npm build, install, start, serve etc). The app is of node.js  

Step 2: Create a AWS Elastic beanstalk with all required configurations and settings. These include the application itself, environment from this app and all settings using terraform rather than the console  The idea is to configure terraform to launch this application with an environment making use of AWS sample application file rather than uploading a zipped version of the react-app in step 1 as this will be done using Github actions through a workflow. Once this sample application is utilised, it then be re-configured to direct to the actual zipped react boiler plate on deployment. 

The workflow is key as this will install all dependencies, build app, prepare deployment package, deploy to Elastic Beanstalk and all other processes. 

A lot of challenges were faced in this project especially with the app itself more so than the terraform configuration. Issues with directory structure and workflow unable to get triggered, a lot of empty references made and workflow would stop. File packaging was also an issue and a lot of  adjustments were made in the apps source files. Port configurations, IAM permissions and health checks also caused me a lot of sleepless nights. Refer to all the commits and versioning in the respective within the repository.   A lot of script adjustment in package.json, server.js and a procfile having to be created were all part of major challenges as I had no experience with node.js and react-app.   In the end, my app was successfully deployed and when you click on the url, it takes you to the initial boiler plate with the text (“Hello our lovlies, Welcome to your favourite island food stop CCFS”) configured in my App.js file within the source directory. The react app deployed within Beanstalk was a success considering the objective of this project.
