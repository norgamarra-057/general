# Requirements

```
cd ~/git/raas/raas_aws/tf_afterhook
gem install bundle
bundle
```
# How to Run
```
cd ~/git/raas/raas_aws/tf_afterhook
# ask raas-team member for a valid wavefront token:
export WF_API_TOKEN=fj99adsf-awef-00af-n299-na39asdfnn21
./hook.rb ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/
```
Note: the wavefront token belongs to the headless user svc_raaswf

Example:
```
$ ./hook.rb ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/
I, [2019-01-22T14:27:34.701798 #70474]  INFO -- : post_search_alerts=https://groupon.wavefront.com/api/v2/search/alert
I, [2019-01-22T14:27:34.918509 #70474]  INFO -- : to_delete=[]
I, [2019-01-22T14:27:34.918585 #70474]  INFO -- : to_create=[]
I, [2019-01-22T14:27:34.918722 #70474]  INFO -- : to_update=[]
Continue? [y/n] n
exit
```
