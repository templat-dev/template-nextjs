---
to: "<%= struct.generateEnable ? `${rootDirectory}/pages/index.tsx` : null %>"
inject: true
skip_if: メニュー <%= struct.name.lowerCamelName %>
after: メニュー
---
        {/* メニュー <%= struct.screenLabel || struct.name.pascalName %> */}
        <Grid item xs={6} sm={6} md={4} lg={3} xl={3}>
          <Card>
            <CardContent>
              <Typography variant="h5" component="div"
                          sx={{mb: 2, display: 'flex', alignItems: 'center'}}>
                <PagesIcon sx={{mr: 1}}/>
                <%= struct.label %>
              </Typography>
              <Typography variant="body2" sx={{mb: 2}}>
                <%= struct.screenLabel || struct.name.pascalName %>の一覧
              </Typography>
            </CardContent>
            <Divider/>
            <CardActions sx={{padding: 0}}>
              <Button fullWidth startIcon={<ArrowForwardIcon/>} size="small"
                      component={Link} href="/<%= struct.name.lowerCamelName %>"
                      sx={{padding: 1.5, justifyContent: 'flex-end'}}>
                <%= struct.screenLabel || struct.name.pascalName %>画面に移動
              </Button>
            </CardActions>
          </Card>
        </Grid>