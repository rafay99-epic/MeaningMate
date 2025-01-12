# Define the root project directory
$projectRoot = "D:\Quiz\lib"

# Create the main directories
$dirs = @(
    "models",
    "services",
    "repositories",
    "screens\auth",
    "screens\home",
    "screens\quiz",
    "widgets",
    "providers",
    "utils"
)

# Create the directories
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $projectRoot $dir)
}

# Create the files in each directory
$files = @{
    "models"       = @(
        "user_model.dart",
        "word_model.dart",
        "quiz_model.dart"
    )
    "services"     = @(
        "auth_service.dart",
        "database_service.dart",
        "quiz_service.dart",
        "ai_service.dart"
    )
    "repositories" = @(
        "auth_repository.dart",
        "word_repository.dart",
        "quiz_repository.dart"
    )
    "screens\auth" = @(
        "login_screen.dart",
        "register_screen.dart",
        "delete_account_screen.dart"
    )
    "screens\home" = @(
        "home_screen.dart",
        "search_screen.dart",
        "add_word_screen.dart"
    )
    "screens\quiz" = @(
        "quiz_screen.dart",
        "quiz_results_screen.dart"
    )
    "widgets"      = @(
        "custom_button.dart",
        "text_field.dart",
        "word_card.dart",
        "quiz_option.dart"
    )
    "providers"    = @(
        "auth_provider.dart",
        "word_provider.dart",
        "quiz_provider.dart"
    )
    "utils"        = @(
        "constants.dart",
        "validators.dart",
        "helpers.dart"
    )
}

# Create the files
foreach ($dir in $files.Keys) {
    foreach ($file in $files[$dir]) {
        New-Item -ItemType File -Force -Path (Join-Path $projectRoot $dir $file)
    }
}

# Create main.dart file
New-Item -ItemType File -Force -Path (Join-Path $projectRoot "main.dart")
