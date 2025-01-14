# Criar um Event Bus personalizado
resource "aws_cloudwatch_event_bus" "custom_event_bus" {
  name = "uploaded-video"
}

# Criar uma regra do EventBridge no Event Bus personalizado para capturar eventos de criação de objetos no bucket S3
resource "aws_cloudwatch_event_rule" "s3_object_created" {
  name           = "S3ObjectCreatedRule"
  description    = "Captura eventos de criação de objetos no bucket S3"
  event_bus_name = aws_cloudwatch_event_bus.custom_event_bus.name # Referência ao Event Bus criado
  event_pattern = jsonencode({
    source = ["aws.s3"]
    detail = {
      eventName = ["PutObject"]
      requestParameters = {
        bucketName = [aws_s3_bucket.my_bucket.bucket]
      }
    }
  })
}

# Criar um destino no EventBridge para a regra
resource "aws_cloudwatch_event_target" "send_to_eventbridge" {
  rule      = aws_cloudwatch_event_rule.s3_object_created.name
  target_id = "eventbridge-target"
  arn       = var.eventbridge_target_arn # Substitua pelo ARN do destino (ex.: Lambda, SQS, etc.)
}

# Permissão para o EventBridge invocar o destino
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.eventbridge_target_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_object_created.arn
}
