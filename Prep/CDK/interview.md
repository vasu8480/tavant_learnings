Perfect! Let’s break this down systematically, keeping answers concise, example-driven, and interview-ready. I’ll cover your points in sequence. I’ll use **TypeScript** as the main CDK language example, since it’s widely recommended for CDK.

---

## **1️⃣ Basics & Fundamentals**

**Q: What is AWS CDK, and how does it differ from CloudFormation?**

* **AWS CDK:** A framework to define cloud infrastructure using programming languages (TypeScript, Python, etc.).
* **Difference from CloudFormation:**

  | Feature     | CloudFormation              | CDK                                    |
  | ----------- | --------------------------- | -------------------------------------- |
  | Language    | YAML/JSON                   | TypeScript, Python, Java, C#, Go, etc. |
  | Reusability | Limited                     | High (constructs, functions)           |
  | Abstraction | Direct resource definitions | High-level constructs (L2/L3)          |
  | Logic       | Harder                      | Can use loops, conditions, functions   |
* **Use case:** Use CDK when you want programmatic, reusable, and maintainable IaC.

---

**Q: Explain CDK app, stack, and construct. How do they relate?**

* **App:** Entry point, groups multiple stacks.
* **Stack:** Represents a CloudFormation stack; contains constructs.
* **Construct:** The basic building block (resource or composition).
* **Relationship:** `App → Stack → Construct`.

Example:

```ts
import * as cdk from 'aws-cdk-lib';
import { Vpc } from 'aws-cdk-lib/aws-ec2';

const app = new cdk.App();
const stack = new cdk.Stack(app, 'MyStack');

new Vpc(stack, 'MyVpc', { maxAzs: 2 });
```

---

**Q: L1, L2, L3 constructs in CDK**

* **L1 (CFN)** → Direct mapping to CloudFormation resource (`CfnBucket`)
* **L2 (Convenience)** → High-level resource with sensible defaults (`Bucket`)
* **L3 (Patterns)** → Opinionated constructs combining multiple resources (`QueueProcessingLambda`)

Example:

```ts
// L1
new s3.CfnBucket(stack, 'MyBucketCfn', { bucketName: 'my-bucket' });
// L2
new s3.Bucket(stack, 'MyBucketL2');
// L3
new s3deploy.BucketDeployment(stack, 'DeployBucket', {
  sources: [s3deploy.Source.asset('./website')],
  destinationBucket: new s3.Bucket(stack, 'WebsiteBucket')
});
```

---

**Q: Languages CDK supports & recommended**

* TypeScript (recommended), Python, Java, C#, Go
* **Recommendation:** TypeScript → first-class support, best docs/examples.

---

**Q: cdk synth, diff, deploy**

* **cdk synth:** Generates CloudFormation template from CDK code.
* **cdk diff:** Shows changes between deployed stack and current code.
* **cdk deploy:** Deploys stack to AWS.

---

**Q: How CDK handles CloudFormation under the hood**

* CDK generates CloudFormation templates → uses CloudFormation to create/update resources.
* CDK is essentially a higher-level abstraction over CFN.

---

## **2️⃣ Constructs & Reusability**

**Q: How to create reusable constructs**

* Extend `Construct` class, pass props.

```ts
export interface MyVpcProps {
  cidr: string;
}

export class MyVpc extends cdk.Construct {
  public readonly vpc: ec2.Vpc;
  constructor(scope: Construct, id: string, props: MyVpcProps) {
    super(scope, id);
    this.vpc = new ec2.Vpc(this, 'VPC', { cidr: props.cidr, maxAzs: 2 });
  }
}
```

**Q: Props in constructs**

* Used to configure resources; passed at instantiation.

**Q: StackProps vs ConstructProps**

* **StackProps:** Passed to `Stack` (env, tags, termination protection).
* **ConstructProps:** Passed to any construct to configure resources inside it.

**Q: Share constructs across projects/teams**

* Publish to npm or internal package registry.
* Import and use in other CDK projects.

**Q: Environment-aware stacks (env parameter)**

```ts
new MyStack(app, 'ProdStack', { env: { account: '111111111111', region: 'us-east-1' } });
```

---

## **3️⃣ CDK Deployment & Lifecycle**

**Q: Updates & rollbacks**

* CDK uses CloudFormation updates → automatic rollback if failure occurs.

**Q: Dependencies between stacks**

```ts
stackB.addDependency(stackA);
```

**Q: cdk.context.json**

* Stores context values (like VPC IDs) to avoid repeated lookups.

**Q: Deploy multiple stacks programmatically**

```ts
const stacks = [new StackA(app, 'A'), new StackB(app, 'B')];
stacks.forEach(stack => cdk.deploy(stack));
```

**Q: Asset handling (Lambda code, Docker images, S3)**

* CDK uploads local files to S3/ECR automatically; Lambda uses these assets.

**Q: Handling secrets**

* Use `SecretValue` or AWS Secrets Manager.

```ts
const secret = cdk.SecretValue.secretsManager('MySecret');
```

---

## **4️⃣ Advanced Patterns & Features**

**Cross-stack references**

```ts
new ec2.SecurityGroup(stackB, 'SG', {
  vpc: stackA.vpc
});
```

**CDK Pipelines**

* High-level constructs to create CI/CD pipelines.
* Supports self-mutating pipelines.

**Classic vs CDK Pipelines**

* Classic: CodePipeline manually defined in CDK.
* CDK Pipelines: High-level abstraction, easier to manage stages.

**Integrate with GitHub/GitLab**

* Trigger pipelines using webhooks → CDK deploy commands.

**Bootstrap stack**

* Required for assets (S3 bucket, IAM roles) before any CDK deployment.

```bash
cdk bootstrap
```

**Aspects**

* Apply operations to all constructs (like tagging, validations).

**Conditional resource creation**

```ts
if (env === 'prod') {
  new s3.Bucket(stack, 'ProdBucket');
}
```

---

## **5️⃣ Security & IAM**

**Assign IAM roles**

```ts
lambda.role?.addManagedPolicy(iam.ManagedPolicy.fromAwsManagedPolicyName('AdministratorAccess'));
```

**Restrict resource creation**

* Use `Condition` or tags in policies.

**Multi-account/multi-region resources**

* Use `env` property in stacks; assume roles programmatically.

**Handle OIDC / cross-account role**

* Use `iam.Role.fromRoleArn` and `sts.assumeRole`.

---

## **6️⃣ Troubleshooting & Best Practices**

* **Debug:** Use `cdk diff`, CloudFormation events, `cdk synth` to inspect templates.
* **Common pitfalls:**

  * S3 bucket name collisions
  * Lambda packaging errors
  * VPC subnet conflicts
* **Prevent accidental deletion:** Use `terminationProtection` or `DeletionPolicy`.
* **Environment configs:** Use context values or props.
* **Large infra optimization:** Split stacks, use L2/L3 constructs, minimize cross-stack references.

---

## **7️⃣ Comparison & Architecture**

| Feature           | CDK                   | CloudFormation | Terraform            |
| ----------------- | --------------------- | -------------- | -------------------- |
| Language          | Programming languages | YAML/JSON      | HCL                  |
| Abstraction       | High (constructs)     | Low            | Medium               |
| Reusability       | Excellent             | Limited        | Medium               |
| State management  | CFN manages           | CFN manages    | Terraform state file |
| CI/CD Integration | Easy                  | Manual         | Easy                 |

**When to choose CDK:**

* Need programmatic control, reusable patterns, high-level abstractions.

---

## **8️⃣ Sample Scenario / Coding**

**VPC with public/private subnets**

```ts
new ec2.Vpc(stack, 'MyVpc', { maxAzs: 2, natGateways: 1 });
```

**Lambda + API Gateway**

```ts
const fn = new lambda.Function(stack, 'Fn', { runtime: lambda.Runtime.NODEJS_18_X, handler: 'index.handler', code: lambda.Code.fromAsset('lambda') });
new apigateway.LambdaRestApi(stack, 'Api', { handler: fn });
```

**DynamoDB table**

```ts
new dynamodb.Table(stack, 'Table', { partitionKey: { name: 'id', type: dynamodb.AttributeType.STRING }, billingMode: dynamodb.BillingMode.PAY_PER_REQUEST });
```

**Refactor repetitive resources**

* Wrap resources into reusable constructs and pass props.

---

✅ This covers all your points, concise, with code examples for interview prep.

If you want, I can **create a one-page “CDK Cheatsheet” with commands, constructs, and patterns** for rapid revision before interviews.

Do you want me to do that next?
