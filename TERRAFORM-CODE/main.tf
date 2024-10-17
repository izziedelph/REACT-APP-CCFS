provider "aws" {
  region = "us-east-1"
}

# Create a new Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "my_react_app" {
  name        = "my-react-app"
  description = "React Application hosted on Elastic Beanstalk"
}

# Create a new IAM Service Role for Elastic Beanstalk
resource "aws_iam_role" "elastic_beanstalk_service_role" {
  name = "my-react-app-eb-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "elasticbeanstalk.amazonaws.com"
      }
    }]
  })
}

# Attach managed policies to the service role
resource "aws_iam_role_policy_attachment" "service_role_policy_attachment" {
  role       = aws_iam_role.elastic_beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "my-react-app-instance-profile"
  role = aws_iam_role.elastic_beanstalk_service_role.name
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "my_react_app_env" {
  name                = "my-react-app-env"
  application         = aws_elastic_beanstalk_application.my_react_app.name
  solution_stack_name = "Node.js 20 running on 64bit Amazon Linux 2023 v6.2.2"  # Platform type

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "my-react-app.pem"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "my-react-app-instance-profile"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "ImageId"
    value     = "ami-01947fda2103bddb4"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
}
