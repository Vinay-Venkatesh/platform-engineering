output "eks_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "oidc provider arn"
}