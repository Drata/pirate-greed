extends CanvasLayer

signal start_game

const MARGIN_SCORE = -450
const MARGIN_BEST_SCORE = 26

func _ready():
	$StartContainer.show()
	$MessageLabel.show()
	$BestScoreContainer/BestScore.show()
	$BestScoreTextContainer.show()
	$Score.hide()
	$MarginContainerScore.hide()
	$MarginContainerTime.hide()

func update_score(value):
	if (value == 10):
		$Score.margin_left = MARGIN_SCORE
	$Score.text = str(value)

func update_best_score(value):
	if (value > 99):
		$BestScoreContainer/BestScore.get_font("font").size = 120

	if (value >= 10):
		$BestScoreContainer.margin_left = MARGIN_BEST_SCORE

	$MarginContainerScore/ScoreLabel.text = "Best " + str(value)
	$BestScoreContainer/BestScore.text = str(value)

func update_timer(value):
	$MarginContainerTime/TimeLabel.text = "~" + str(value) + "~"

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	$Score.hide()
	$MarginContainerScore.hide()
	$MarginContainerTime.hide()
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$BestScoreContainer/BestScore.show()
	$BestScoreTextContainer.show()
	$StartContainer.show()
	$MessageLabel.text = "Pirate Greed"
	$MessageLabel.show()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_StartButton_pressed():
	$StartContainer.hide()
	$MessageLabel.hide()
	$BestScoreContainer/BestScore.hide()
	$BestScoreTextContainer.hide()
	$Score.show()
	$MarginContainerScore.show()
	$MarginContainerTime.show()
	emit_signal("start_game")
