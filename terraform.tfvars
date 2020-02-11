aws_profile		= "ankit"
aws_region		= "us-east-1"
vpc_cidr                = "20.0.0.0/16"

cidrs			= {
  public1  = "20.0.1.0/24"
  public2  = "20.0.2.0/24"
  private1 = "20.0.3.0/24"
  private2 = "20.0.4.0/24"
  rds1	   = "20.0.5.0/24"
  rds2     = "20.0.6.0/24"
  rds3     = "20.0.7.0/24"
}
/*
db_instance_class	= "db.t2.micro"
dbname			= "mydb"
dbuser			= "root"
dbpassword		= "wordpress"
*/
key_name		= "terrakey"
public_key_path		= "/home/ec2-user/.ssh/terrakey.pub"
dev_instance_type	= "t2.micro"
dev_ami			= "ami-062f7200baf2fa504"
/*
elb_healthy_threshold   = "2"
elb_unhealthy_threshold = "2"
elb_timeout 		= "3"
elb_interval		= "30"
asg_max 		= "2"
asg_min			= "1"
asg_grace		= "300"
asg_hct			= "EC2"
asg_cap			= "2"
lc_instance_type	= "t2.micro"
delegation_set 		= "N1HDAZB52OQ3IV"
*/
