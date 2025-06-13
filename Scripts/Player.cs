using Godot;

public partial class Player : CharacterBody3D
{
	[Export] public Camera3D Camera { get; set; }
	[Export] public float MouseSensitivity { get; set; } = 0.005f;
	private float yaw = 0.0f;
	private float pitch = 0.0f;

	[Export] public float WalkSpeed { get; set; } = 5.0f;
	[Export] public float SprintSpeed { get; set; } = 8.0f;
	[Export] public float JumpStrength { get; set; } = 4.5f;
	[Export] public float Gravity { get; set; } = 9.8f;

	private float speed;
	private Vector3 direction = Vector3.Zero;

	public override void _Ready()
	{
		if (Camera == null)
		{
			GD.PrintErr("Камера не установлена!");
		}
		Input.MouseMode = Input.MouseModeEnum.Captured;
		speed = WalkSpeed;
	}

	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventMouseMotion mouseMotion && Input.MouseMode == Input.MouseModeEnum.Captured)
		{
			yaw -= mouseMotion.Relative.X * MouseSensitivity;
			pitch -= mouseMotion.Relative.Y * MouseSensitivity;
			pitch = Mathf.Clamp(pitch, -Mathf.Pi / 2, Mathf.Pi / 2);
			Rotation = new Vector3(Rotation.X, yaw, Rotation.Z);
			if (Camera != null)
			{
				Camera.Rotation = new Vector3(pitch, 0, 0);
			}
		}

		if (@event.IsActionPressed("ui_cancel"))
		{
			GetTree().Quit();
		}

		// Добавлено: переключение режима курсора по нажатию P
		if (@event.IsActionPressed("toggle_mouse_capture"))
		{
			if (Input.MouseMode == Input.MouseModeEnum.Captured)
			{
				Input.MouseMode = Input.MouseModeEnum.Visible;
			}
			else
			{
				Input.MouseMode = Input.MouseModeEnum.Captured;
			}
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		if (!IsOnFloor())
		{
			Velocity = new Vector3(Velocity.X, Velocity.Y - (float)(Gravity * delta), Velocity.Z);
		}
		else
		{
			Velocity = new Vector3(Velocity.X, 0, Velocity.Z);
		}

		if (Input.IsActionJustPressed("jump") && IsOnFloor())
		{
			Velocity = new Vector3(Velocity.X, JumpStrength, Velocity.Z);
		}

		if (Input.IsActionPressed("sprint"))
		{
			speed = SprintSpeed;
		}
		else
		{
			speed = WalkSpeed;
		}

		float inputX = Input.GetActionStrength("ui_right") - Input.GetActionStrength("ui_left");
		float inputY = Input.GetActionStrength("ui_down") - Input.GetActionStrength("ui_up");
		Vector2 inputDir = new Vector2(inputX, inputY).Normalized();

		Vector3 forward = -GlobalTransform.Basis.Z;
		Vector3 right = GlobalTransform.Basis.X;
		forward.Y = 0;
		forward = forward.Normalized();
		right.Y = 0;
		right = right.Normalized();
		direction = (forward * inputDir.Y + right * inputDir.X).Normalized();

		if (direction != Vector3.Zero)
		{
			Velocity = new Vector3(direction.X * speed, Velocity.Y, direction.Z * speed);
		}
		else
		{
			Velocity = new Vector3(0, Velocity.Y, 0);
		}

		MoveAndSlide();
	}
}
