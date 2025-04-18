![GCP Architecture Diagram](assets/diagram.svg)

# ☁️ GCP + Terraform + Dataproc Setup Guide

## 1. Create GCP Account

- Sign up at [https://cloud.google.com](https://cloud.google.com)

## 2. Install `gcloud`

- Follow instructions: [Install Google Cloud CLI](https://cloud.google.com/sdk/docs/install)

## 3. Create Service Account for Terraform

Assign the following roles:

- `BigQuery Admin`
- `Storage Admin`
- `Storage Object Admin`

## 4. Install Terraform

- [Terraform Installation Guide](https://developer.hashicorp.com/terraform/downloads)

> Based on:  
> [DataTalksClub Terraform GCP Guide](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/01-docker-terraform/1_terraform_gcp/2_gcp_overview.md)

## 5. Set Environment Variables

```bash
export GOOGLE_CREDENTIALS=$HOME/.google/credentials/google_credentials.json
export PATH=$HOME/bin/terraform:$PATH
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.google/credentials/google_credentials.json
```

⚠️ **Important**: Update `spark_sql.py` and `variables.tf` with:

- Your GCP **Project ID**
- Your **Bucket Name(s)**

## 6. Enable Required APIs

Enable in browser:

- [IAM API](https://console.cloud.google.com/apis/library/iam.googleapis.com)
- [IAM Credentials API](https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com)

## 7. Run Terraform

```bash
terraform init
terraform plan
terraform apply
# terraform destroy (optional)
```

## 8. Create Dataproc Cluster (via Web Console)

- Enable **Dataproc API**
- Choose region **same** as in `variables.tf`

⚙️ Update this line in `spark_sql.py`:

```python
spark.conf.set("temporaryGcsBucket", "<YOUR TEMP DATAPROC BUCKET>")
```

## 9. Upload to Terraform-Created Bucket

⚠️ **Important**: Unzip `crimes-in-toronto.gz` to receive `crimes-in-toronto.csv`

Upload the following:

- `spark_sql.py`
- `crimes-in-toronto.csv`

## 10. Submit PySpark Job in Dataproc

- **Job Type**: PySpark
- **Main class or JAR**:  
  `gs://<your-tf-bucket>/spark_sql.py`
- **Arguments**:
  ```bash
  --input_csv_file=gs://<your-bucket>/crimes-in-toronto.csv
  --output_bq_table=dez2025_tf_dataset.crimes
  ```

ℹ️ No need to manually add JARs when using modern Dataproc images.

## 11. Result: BigQuery Table Created

- Table `crimes` now exists in BigQuery under `dez2025_tf_dataset`.

## 12. Run SQL Optimizations in BigQuery

Using `big_query.sql`, perform:

- Creation of **partitioned** table
- Creation of **partitioned & clustered** table
- Comparison of **scan performance** between table types

✅ Result: Partitions and clusters improve performance.

## 13. Final Result: Looker Studio Report

View the report here:  
📊 [Looker Report](https://lookerstudio.google.com/reporting/107f5bc7-2939-4f78-9db9-3eea07a72e44)
