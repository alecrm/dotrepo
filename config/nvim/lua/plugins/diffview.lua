return {
	{
		'sindrets/diffview.nvim',
		version = false,
		event = { 'BufReadPre', 'BufNewFile'},
		config = function()
			require('diffview').setup()
		end
	}
}
