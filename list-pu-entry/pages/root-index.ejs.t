---
to: "<%= entity.enable ? `${rootDirectory}/${projectName}/pages/index.tsx` : null %>"
inject: true
skip_if: メニュー <%= entity.name %>
after: メニュー
---
        {/* メニュー <%= entity.name %> */}
        <Grid item xs={6} sm={6} md={4} lg={3} xl={3}>
          <Card>
            <CardContent>
              <Typography variant="h5" component="div"
                          sx={{mb: 2, display: 'flex', alignItems: 'center'}}>
                <PagesIcon sx={{mr: 1}}/>
                <%= entity.label %>
              </Typography>
              <Typography variant="body2" sx={{mb: 2}}>
                <%= entity.label %>の一覧
              </Typography>
            </CardContent>
            <Divider/>
            <CardActions sx={{padding: 0}}>
              <Button fullWidth startIcon={<ArrowForwardIcon/>} size="small"
                      component={Link} href="/<%= entity.name %>"
                      sx={{padding: 1.5, justifyContent: 'flex-end'}}>
                <%= entity.listLabel %>画面に移動
              </Button>
            </CardActions>
          </Card>
        </Grid>