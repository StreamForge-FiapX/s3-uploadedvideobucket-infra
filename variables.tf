# Variáveis necessárias
variable "eks_node_iam_role_arn" {
  description = "ARN do papel IAM dos nós do EKS que terão acesso ao bucket S3"
  type        = string
  default     = "arn:aws:iam::307946636040:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"
}

variable "eventbridge_target_arn" {
  description = "ARN do destino no EventBridge (por exemplo, uma Lambda ou fila SQS)"
  type        = string
  default     = "arn:aws:lambda:sa-east-1:307946636040:function:uploaded_video"
}
