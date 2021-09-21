# Creating a Database System from a backup 

This set of Terraform scripts creates a database based on a backup.

The idea behind the post is to enable the "refresh" of a database system over night. As such it is expected the auxiliary structures (Network, Security Lists, Network Security Groups etc) are already in place. The script expects these to be passed as variables. The most common approach is to populate shell (environment) variables as explained in the post.

## Cost Warning

Be aware that executing the code will incur cost!

## Reference 
Please [refer to the blog post](https://martincarstenbach.wordpress.com/2021/03/24/oracle-database-cloud-service-create-a-database-from-backup-using-terraform//) for more details.