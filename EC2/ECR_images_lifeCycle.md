README.md
AWS ECR Lifecycle Policy Automation
This guide walks you through creating and applying a lifecycle policy for your AWS Elastic Container Registry (ECR) repositories. The policy is designed to retain the latest 10 container images and delete older ones.
Prerequisites
- Access to AWS CloudShell or a local terminal with AWS CLI installed.
- Sufficient permissions to create lifecycle policies in AWS ECR.
Step-by-Step Instructions
1. Create the `lifecycle-policy.json` file
1. Open your terminal:
- Use AWS CloudShell for convenience within the AWS Management Console, or use your local terminal if you have AWS CLI configured.
2. Create a new file named `lifecycle-policy.json`.
- You can create this file using a text editor or by running the following command directly in your terminal:
    ```bash
    echo '{
        "rules": [
            {
                "rulePriority": 1,
                "description": "Keep the latest 10 images, delete the rest",
                "selection": {
                    "tagStatus": "any",
                    "countType": "imageCountMoreThan",
                    "countNumber": 10
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }' > lifecycle-policy.json
    ```
2. Apply the Lifecycle Policy
1. Ensure the `lifecycle-policy.json` file is in your current directory:
- This location must be where you execute the following script.
2. Run the script to apply the lifecycle policy to each repository:
    ```bash
    # List all repository names
    repos=$(aws ecr describe-repositories --query 'repositories[*].repositoryName' --output text)

    # Apply the lifecycle policy to each repository and log the actions
    for repo in $repos; do
        echo "Applying lifecycle policy to repository: $repo" >> /var/log/lifecycle_policy_apply.log
        aws ecr put-lifecycle-policy --repository-name "$repo" --lifecycle-policy-text file://lifecycle-policy.json >> /var/log/lifecycle_policy_apply.log 2>&1
    done
    ```
    ```bash
    cat /var/log/lifecycle_policy_apply.log
    ```
Key Steps and Considerations
- Directory Check: Always confirm that `lifecycle-policy.json` is in the directory from which commands are executed.
- Environment:
- If using AWS CloudShell, make sure your file resides in the CloudShell environment.
- Permissions: The AWS CLI must be configured with credentials that have necessary permissions to modify ECR repository policies.
Conclusion
By following these steps, you can automate the management of container image lifetimes in your AWS ECR, helping to save storage costs and maintain an organized repository. Review and adjust the lifecycle policy parameters according to your organizational requirements.