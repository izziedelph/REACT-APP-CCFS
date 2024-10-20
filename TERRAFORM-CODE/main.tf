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
        Service = ["elasticbeanstalk.amazonaws.com", "ec2.amazonaws.com"]
      }
    }]
  })
}

# Attach necessary policies to the service role
resource "aws_iam_role_policy_attachment" "service_role_policy_attachment1" {
  role       = aws_iam_role.elastic_beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "service_role_policy_attachment2" {
  role       = aws_iam_role.elastic_beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# Create EC2 instance profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "my-react-app-instance-profile"
  role = aws_iam_role.elastic_beanstalk_service_role.name
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "my_react_app_env" {
  name                = "my-react-app-env"
  application         = aws_elastic_beanstalk_application.my_react_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.2.2 running Node.js 20"

  # General Settings
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"  # or LoadBalanced if you need load balancing
  }

  # Instance Settings
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  # Application Settings
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "production"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NPM_USE_PRODUCTION"
    value     = "false"  # This ensures dev dependencies are installed
  }

  # Health Reporting Settings
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"  # Health check path
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = "8081"  # Match this with your server.js port
  }

  # Deployment Settings
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "AllAtOnce"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "Timeout"
    value     = "600"  # Increase deployment timeout
  }

  # Monitoring Settings
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }

  # Log Streaming
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     = "true"
  }
}

# Output the environment URL
output "environment_url" {
  value = aws_elastic_beanstalk_environment.my_react_app_env.endpoint_url
}