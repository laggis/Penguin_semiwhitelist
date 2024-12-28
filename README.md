# Penguin Semi-Whitelist

A FiveM resource that implements a semi-whitelist system for your server, allowing you to manage player access with flexible options.

## Features

- **Semi-Whitelist System:**
  - Configurable whitelist checks
  - Support for both whitelisted and non-whitelisted players
  - Custom queue management

- **Queue Management:**
  - Priority queue system
  - Configurable queue positions
  - Special handling for whitelisted players

- **Customization:**
  - Configurable messages
  - Adjustable settings
  - Easy-to-modify priority system

## Dependencies

- FiveM Server
- MySQL or similar database (optional, depending on implementation)

## Installation

1. Download the latest release from the [releases page](https://github.com/laggis/Penguin_semiwhitelist/releases)
2. Extract the files to your FiveM resources folder
3. Add `ensure Penguin_semiwhitelist` to your server.cfg
4. Configure the settings to match your server's needs

## Configuration

Adjust the configuration files to customize the semi-whitelist system according to your server's requirements:

```lua
-- Example configuration (adjust according to actual config options)
Config = {
    EnableWhitelist = true,
    MaxPlayers = 32,
    PriorityQueueEnabled = true,
    -- Add other configuration options as needed
}
```

## Usage

The system will automatically:
1. Check connecting players against the whitelist
2. Place players in appropriate queue positions
3. Manage server access based on configuration settings

## Commands

- Add any relevant admin commands for managing the whitelist
- Include queue management commands
- Whitelist status checking commands

## Support

For support:
1. Create an issue in this repository
2. Join our Discord server (if available)
3. Contact the maintainers

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

Created by Laggis
