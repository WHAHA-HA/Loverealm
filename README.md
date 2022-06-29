# README #

### Organize Git ###
* **master**  - branch for production, only tested features from staging merge to master.
* **staging** - branch for staging (test) version. Pre-production version of application.
* **dev** - branch for development, local branches ( specific features) merge to dev.
* **local_branch** - branches for development particular features (*name as last part of trello url for that feature*); these branches need to be at your machine until it is ready to production.

### Necessary things ###
* Rails 4.1.8
* Ruby 2.1.5
* PostgreSql 9.3
* Additional packages: libsnappy-dev

### How do I get set up? ###
  * Clone dev branch.
  * Get into project via console and run bundle install.
  * Run rake db:create db:migrate db:seed
  * Create your local branch - git checkout -b branch_name from dev
  *  After you finish particular feature, commit and push your local branch (! add meaningful commit message for better       understanding)

### Development process ###
* FrontEnd team and BackEnd team.
* After particular feature from *FE/BE* is finished, move it to *Review* and assign another guy from your team, with appropriate comment and branch name. Also, very important thing is to create **PULL REQUEST** on bitbucket and to assign the same guy as on Trello.
* When this feature is reviewed by colleague, he needs to move it to *For Testing*, merge to **dev** branch and set flag color **YELLOW**. All yellow ticket need to be deployed to Staging Version(BE team) and then assigned to Product Owner. BE team, need to merge all *yellow* features from *For Testing* to **staging** branch and deploy to Staging Version.
*  Product Owner can test only yellow tickets from *For Testing* which are assigned to him, and after everything is ok, move it to *Approved and Tested By Product Owner*; if something missing or wrong, move ticket to *Bugs* and change flag colour to **RED** with appropriate comment related to bug. Project Lead, in meantime, assigns tickets from *Bugs* to ticket owner.
* Tickets in *Bugs* have priority.
* All tickets in *Approved and Tested By Product Owner* are ready for production. Local branches for approved features have to be merged into master and then do deploy to production. After they deployed on live, local branch and remote branch for that particular feature can be removed.

### List of scheduled jobs ###
* [daily] rake sitemap:refresh

### RabbitMQ Setup ###
* Set Env RABBIT_AMQP=amqp://[user]:[password]@[rabbitmq server url]
* Run this command to create exchange and queue on RabbitMQ Server if server doesn't have. rake rabbitmq:setup
* Run this command to run sneakers(RabbitMQ worker). rake sneakers:run