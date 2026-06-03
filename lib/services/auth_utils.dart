String translateAuthError(String message) {
  if (message.contains('Invalid login credentials')) {
    return 'Email ou mot de passe incorrect.';
  } else if (message.contains('User already registered')) {
    return 'Cet email est déjà utilisé.';
  } else if (message.contains('Password should be at least')) {
    return 'Le mot de passe doit faire au moins 6 caractères.';
  }
  return message; // Retourne le message original si on ne le connaît pas
}
