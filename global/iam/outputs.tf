output "uppercase_user_map" {
  value       = { for user, ability in var.users_ability : upper(user) => upper(ability) }
  description = "convert user list to "
}

output "for_decleritive" {
  value = "%{for user, ablility in var.users_ability} ${user} -> ${ablility} %{endfor}"
}

output "neo_access_arn" {
  value = one(concat(
    aws_iam_policy.cloudwatch_full_access[*].policy_arn,
    aws_iam_policy.cloudwatch_read_only[*].policy_arn
    )
  )
}

output "for_directive_index_if" {
  value = <<EOF
  %{~for i, name in var.users~}
  ${name}%{if length(var.users) - 1 > i}, %{else}.
   %{endif}
  %{~endfor~}
  EOF
}